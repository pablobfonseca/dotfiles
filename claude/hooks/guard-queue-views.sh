#!/usr/bin/env bash
# Queue.md is written by `claudeos queue` only. Runs as Claude Code's and Codex's PreToolUse and as
# Gemini CLI's BeforeTool, told apart by hook_event_name (guard-dialect.sh). Refuses every edit or
# write on the vault's generated views and on the vault-queues authority (Claude's Edit and Write,
# Gemini's replace and write_file, Codex's apply_patch, whose tool_input.command is the patch text) and
# any shell command that names either (Bash, run_shell_command); reads go through `claudeos queue dump`
# and `claudeos queue find`. The one exception is an edit on the authority while
# `claudeos queue edit <project> begin` has an open session (<repo>/.git/queue-tool-edit/<project>, the
# marker path the Python queue-tool used, kept by the port): Edit, replace, and an apply_patch whose
# every Queue.md file header is an `*** Update File:` under one, with no `*** Move to:` into or out of
# a Queue.md. Patch headers are read trimmed, as Codex parses them, and only `+` lines are content.
# Relative paths are joined to the payload's cwd first; Gemini and Codex send them. Without a cwd a
# relative path cannot be placed, so any one ending in Queue.md is refused.
# Every match ignores case: macOS opens queue.md as Queue.md. The exception does not: a path spelled
# in another case is refused under an open session too.
# A shell command is read with its line continuations joined and its quotes and backslashes dropped
# (guard-dialect.sh). It also names a Queue.md through a relative word that the cwd, or a `cd` target
# in the command (each relative target joined to the one before, options skipped, quoted and bare
# pieces read as one target), places on a guarded path. A word counts when its last part is Queue.md
# or a glob or brace list that can expand to it (Queue.m[d], *.md, {Queue,Design}.md), so in a queue
# project directory `ls *.md` is refused too. Words also end at `=` (of=Queue.md). More than MAX_CD
# `cd` targets beside such a word, or more than MAX_PLACE placements, is refused unread: a guard that
# runs past its hook timeout does not block. A payload jq cannot read a command, patch or path from
# is refused. Not followed: variables, command substitution, eval, $'…' quoting, scripts and
# interpreters, pushd, git -C, symlinks, a glob in a directory name, a directory handed to a
# recursive tool. With no cwd and no `cd` a bare Queue.md word is allowed: a grep pattern cannot be
# told from a path.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-dialect.sh"

QUEUE_RE='(SecondBrain/projects|vault-queues|(^|[^[:alnum:]_/.-])projects)/[^/[:space:]]+/Queue\.md'
read -r -d '' REASON <<'EOF'
Queue.md is written by claudeos queue only: the vault's projects/<P>/Queue.md is a GENERATED READ-ONLY VIEW, overwritten on the next queue write, and the vault-queues copy is the authority it regenerates from, where a hand edit leaves the repo dirty and every later queue write refused. Use the tool: claudeos queue state|lane|mark|add|stamp <project> <qN> ... for single-line changes, `claudeos queue edit <project> begin` then `claudeos queue edit <project> commit -m "..."` for free-form grooming, and claudeos queue dump|find <project> to read. Run `claudeos queue --help` for syntax.
EOF
read -r -d '' OVERRUN <<'EOF'
The queue guard could not place every path in this command: it has too many cd targets or too many words that could name a Queue.md, and a command the guard cannot finish reading is refused. Split it into shorter commands, or write the file with the Write tool instead of a heredoc.
EOF

clean_path() { # <path>: sets $placed to the path with its empty, `.` and `..` parts resolved
  local part out=() parts
  IFS=/ read -ra parts <<<"$1"
  for part in "${parts[@]}"; do
    case $part in
      ''|.) ;;
      ..) (( ${#out[@]} )) && out=("${out[@]:0:${#out[@]}-1}") ;;
      *) out+=("$part") ;;
    esac
  done
  local IFS=/
  if [[ $1 == /* ]]; then placed="/${out[*]-}"; else placed="${out[*]-}"; fi
}

absolute() { # <path> [base]: sets $placed; a relative path is joined to the base, the payload's cwd unless one is given, if any
  local p=$1 base=${2-$cwd}
  [[ $p == /* || -z $base ]] || p="$base/$p"
  clean_path "$p"
}

is_queue() { # <path from absolute>: a guarded Queue.md, or any Queue.md left relative for want of a cwd
  [[ $1 =~ $QUEUE_RE ]] || [[ $1 != /* && ${1##*/} == Queue.md ]]
}

session_open() { # <absolute .../<project>/Queue.md>: `claudeos queue edit <project> begin` is in flight
  local project_dir=${1%/Queue.md}
  [[ $1 == /*/Queue.md && -f ${project_dir%/*}/.git/queue-tool-edit/${project_dir##*/} ]]
}

MAX_CD=16      # cd targets read beside a Queue.md word
MAX_PLACE=512  # (Queue.md word, base) pairs placed
MAX_WORD=4096  # a longer word or cd target is no path
MAX_BRACES=8   # brace lists read in one word
CD_RE="(^|[;&|(){}[:space:]])cd(([[:space:]]+-[-LPe@]*)*)[[:space:]]+((\"[^\"]*\"|'[^']*'|\\\\.|[^;&|()<>[:space:]\"'\\\\])+)(.*)\$"
BRACE_RE='^(.*)\{[^{}]*\}(.*)$'
QUOTES=$'["\'\\\\]'
# Words are split by IFS and tested by glob, and nothing here forks: bash 3.2 runs ${var//pattern/}
# and ${word##*/} in quadratic time, so both are kept to words of MAX_WORD at most, and a subshell
# per placement is what let a 2.6 KB command run for 12 s.
WORD_BREAK=$' \t\n;&|<>()`='

shell_names_queue() { # <command> <command dequoted>: a word that the cwd, or a `cd` target in the command, places on a guarded Queue.md
  local rest=$1 base=$cwd bases=("$cwd") target words word name named=() n
  IFS=$WORD_BREAK read -r -d '' -a words <<<"$2"
  (( ${#words[@]} )) || return 1
  for word in "${words[@]}"; do
    (( ${#word} > MAX_WORD )) && continue
    n=0
    while (( n++ < MAX_BRACES )) && [[ $word =~ $BRACE_RE ]]; do word="${BASH_REMATCH[1]}*${BASH_REMATCH[2]}"; done
    name=${word##*/}
    [[ Queue.md == $name ]] && named+=("${word%"$name"}Queue.md")
  done
  (( ${#named[@]} )) || return 1
  while [[ $rest =~ $CD_RE ]]; do
    rest=${BASH_REMATCH[6]}
    target=${BASH_REMATCH[4]}
    (( ${#target} > MAX_WORD )) && continue
    (( ${#bases[@]} > MAX_CD )) && guard_deny "$event" "$OVERRUN"
    absolute "${target//$QUOTES/}" "$base"
    base=$placed
    bases+=("$base")
  done
  (( ${#named[@]} * ${#bases[@]} > MAX_PLACE )) && guard_deny "$event" "$OVERRUN"
  for word in "${named[@]}"; do
    for base in "${bases[@]}"; do
      absolute "$word" "$base"
      [[ $placed =~ $QUEUE_RE ]] && return 0
    done
  done
  return 1
}

input=$(cat) || exit 0
event=$(jq -r '.hook_event_name // empty' <<<"$input" 2>/dev/null) || exit 0
tool=$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null) || exit 0
cwd=$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null) || exit 0

case "$tool" in
  Bash|run_shell_command)
    cmd=$(jq -r "$COMMAND_JQ" <<<"$input" 2>/dev/null) || guard_deny "$event" "$REASON"
    text=$(jq -r "$DEQUOTED_JQ" <<<"$input" 2>/dev/null) || guard_deny "$event" "$REASON"
    [[ $cmd =~ $QUEUE_RE || $text =~ $QUEUE_RE ]] || shell_names_queue "$cmd" "$text" || guard_allow "$event"
    guard_deny "$event" "$REASON"
    ;;
  apply_patch)
    patch=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null) || guard_deny "$event" "$REASON"
    from_queue=
    while IFS= read -r line; do
      header=${line#"${line%%[![:space:]]*}"}
      header=${header%"${header##*[![:space:]]}"}
      if [[ $header =~ ^\*\*\*\ (Update|Add|Delete)\ File:\ (.+)$ ]]; then
        op=${BASH_REMATCH[1]}
        absolute "${BASH_REMATCH[2]}"
        path=$placed
        from_queue=
        is_queue "$path" || continue
        from_queue=1
        [[ $op == Update ]] && session_open "$path" && continue
        guard_deny "$event" "$REASON"
      elif [[ $header =~ ^\*\*\*\ Move\ to:\ (.+)$ ]]; then
        absolute "${BASH_REMATCH[1]}"
        [[ -z $from_queue ]] && ! is_queue "$placed" && continue
        guard_deny "$event" "$REASON"
      elif [[ $line == +* && $line =~ $QUEUE_RE ]]; then
        guard_deny "$event" "$REASON"
      fi
    done <<<"$patch"
    guard_allow "$event"
    ;;
  *)
    file=$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null) || guard_deny "$event" "$REASON"
    [[ -n $file ]] || guard_allow "$event"
    absolute "$file"
    target=$placed
    is_queue "$target" || guard_allow "$event"
    case "$tool" in Edit|replace) session_open "$target" && guard_allow "$event" ;; esac
    guard_deny "$event" "$REASON"
    ;;
esac
