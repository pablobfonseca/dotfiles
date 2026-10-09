#!/usr/bin/env bash
# Queue.md is written by `claudeos queue` only. Runs as Claude Code's and Codex's PreToolUse and as
# Gemini CLI's BeforeTool, told apart by hook_event_name (guard-dialect.sh). Refuses every edit or
# write on the vault's generated views and on the vault-queues authority (Claude's Edit and Write,
# Gemini's replace and write_file, Codex's apply_patch, whose tool_input.command is the patch text) and
# any shell command that names either (Bash, run_shell_command) unless it only reads it. The one
# exception to the edit rule is an edit on the authority while `claudeos queue edit <project> begin`
# has an open session (<repo>/.git/queue-tool-edit/<project>, the marker path the Python queue-tool
# used, kept by the port): Edit, replace, and an apply_patch whose every Queue.md file header is an
# `*** Update File:` under one, with no `*** Move to:` into or out of a Queue.md. Patch headers are
# read trimmed, as Codex parses them, and only `+` lines are content.
# Relative paths are joined to the payload's cwd first; Gemini and Codex send them. Without a cwd a
# relative path cannot be placed, so any one ending in Queue.md is refused.
# Every match ignores case: macOS opens queue.md as Queue.md. The exception does not: a path spelled
# in another case is refused under an open session too.
# A shell command is read with its line continuations joined and its quotes and backslashes dropped
# (guard-dialect.sh). It also names a Queue.md through a relative word that the cwd, or a `cd` target
# in the command (each relative target joined to the one before, options skipped, quoted and bare
# pieces read as one target), places on a guarded path. A word counts when its last part is Queue.md
# or a glob or brace list that can expand to it (Queue.m[d], *.md, {Queue,Design}.md). Words also end
# at `=` (of=Queue.md). More than MAX_CD `cd` targets beside such a word, or more than MAX_PLACE
# placements, is refused unread: a guard that runs past its hook timeout does not block. A payload jq
# cannot read a command, patch or path from is refused.
# A command that names a guarded Queue.md is still allowed when it only reads it: EVERY segment of
# the command (split at ; & | ( ) newline and backtick), named or not, starts with one of READERS as
# a bare word (no path, no env assignment, no sudo, env, xargs or time in front), and no word that
# could name a Queue.md follows a > redirect anywhere (>, >>, >|, >!, &>, 2>, <>); more than
# MAX_REDIRECT redirects or MAX_SEGMENT segments beside such a word is refused unread, like the cd
# cap (20000 segments took 8 s under bash 3.2, against the 10 s hook timeout). Checking every
# segment is what refuses a reader's output reaching a writer (`$(ls Queue.md)`, `| xargs rm`), a
# redefined reader (`cat(){ …; }`, `PATH=…`) and a zsh glob qualifier (`Queue.md(e:…:)`). So in a
# queue project directory `ls *.md`, `cat Queue.md | head` and `grep -n x Queue.md` are allowed and
# `sed -i`, `tee`, `cp`, `>>`, `echo`, `rg` (--pre, -z) and every unlisted program are refused. sed
# is not a reader: its script writes (`w file`, GNU `e cmd`) and a word test cannot tell that from a
# read. Not followed: variables, eval, $'…' quoting, scripts and interpreters, pushd, git -C,
# symlinks, a glob in a directory name, a directory handed to a recursive tool, `file -C`, a `{ …; }`
# group (its head word is `{`), a `>` inside a pattern (`grep '>' Queue.md` reads as a redirect). With
# no cwd and no `cd` a bare Queue.md word is allowed: a grep pattern cannot be told from a path.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-dialect.sh"

QUEUE_RE='(SecondBrain/projects|vault-queues|(^|[^[:alnum:]_/.-])projects)/[^/[:space:]]+/Queue\.md'
read -r -d '' REASON <<'EOF'
Queue.md is written by claudeos queue only: the vault's projects/<P>/Queue.md is a GENERATED READ-ONLY VIEW, overwritten on the next queue write, and the vault-queues copy is the authority it regenerates from, where a hand edit leaves the repo dirty and every later queue write refused. Use the tool: claudeos queue state|lane|mark|add|stamp <project> <qN> ... for single-line changes, `claudeos queue edit <project> begin` then `claudeos queue edit <project> commit -m "..."` for free-form grooming, and claudeos queue dump|find <project> to read. Run `claudeos queue --help` for syntax. A plain read of the file is allowed: ls, cat, head, tail, wc, grep, stat, diff, file, cut or nl as the bare command word of every part of the command, with no > redirect onto the file; this command is not one.
EOF
read -r -d '' OVERRUN <<'EOF'
The queue guard could not place every path in this command: it has too many cd targets, too many > redirects, too many command segments or too many words that could name a Queue.md, and a command the guard cannot finish reading is refused. Split it into shorter commands, or write the file with the Write tool instead of a heredoc.
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
MAX_REDIRECT=64 # > redirects read beside a Queue.md word
MAX_SEGMENT=4096 # command segments read beside a Queue.md word
CD_RE="(^|[;&|(){}[:space:]])cd(([[:space:]]+-[-LPe@]*)*)[[:space:]]+((\"[^\"]*\"|'[^']*'|\\\\.|[^;&|()<>[:space:]\"'\\\\])+)(.*)\$"
BRACE_RE='^(.*)\{[^{}]*\}(.*)$'
QUOTES=$'["\'\\\\]'
# Words are split by IFS and tested by glob, and nothing here forks: bash 3.2 runs ${var//pattern/}
# and ${word##*/} in quadratic time, so both are kept to words of MAX_WORD at most, and a subshell
# per placement is what let a 2.6 KB command run for 12 s.
WORD_BREAK=$' \t\n;&|<>()`='
# The read exception: programs that only read the files named on their command line, and cd, which
# only moves where the next one reads.
READERS=' ls cat head tail wc grep stat diff file cut nl cd '
SEGMENT_BREAK=$'\n;&|()`'
HEAD_BREAK=$' \t'
REDIRECT_RE='>[>|&!]*[[:space:]]*([^[:space:];&|<>()`=]+)(.*)$'

names_queue() { # <dequoted word>: its last part could expand to Queue.md, or it holds a guarded path
  local word=$1 n=0
  [[ $word =~ $QUEUE_RE ]] && return 0
  if (( ${#word} > MAX_WORD )); then [[ $word == *{* ]]; return; fi
  [[ $word == -[[:alpha:]]* ]] && word=${word#-?}
  while (( n++ < MAX_BRACES )) && [[ $word =~ $BRACE_RE ]]; do word="${BASH_REMATCH[1]}*${BASH_REMATCH[2]}"; done
  [[ $word =~ $BRACE_RE ]] && return 0
  [[ Queue.md == ${word##*/} ]]
}

shell_names_queue() { # <command> <command dequoted>: a word that the cwd, or a `cd` target in the command, places on a guarded Queue.md
  local rest=$1 base=$cwd bases=("$cwd") target words word name named=() n
  IFS=$WORD_BREAK read -r -d '' -a words <<<"$2"
  (( ${#words[@]} )) || return 1
  for word in "${words[@]}"; do
    if (( ${#word} > MAX_WORD )); then
      [[ $word == *{* ]] && named+=(Queue.md)
      continue
    fi
    [[ $word == -[[:alpha:]]* ]] && word=${word#-?}
    n=0
    while (( n++ < MAX_BRACES )) && [[ $word =~ $BRACE_RE ]]; do word="${BASH_REMATCH[1]}*${BASH_REMATCH[2]}"; done
    if [[ $word =~ $BRACE_RE ]]; then
      name=${word%%\{*}
      named+=("${name%"${name##*/}"}Queue.md")
      continue
    fi
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

shell_reads_queue() { # <command dequoted>: every segment starts with a bare reader, and no Queue.md word follows a > redirect
  local rest=$1 segments segment head args n=0
  while [[ $rest =~ $REDIRECT_RE ]]; do
    (( n++ < MAX_REDIRECT )) || guard_deny "$event" "$OVERRUN"
    rest=${BASH_REMATCH[2]}
    names_queue "${BASH_REMATCH[1]}" && return 1
  done
  IFS=$SEGMENT_BREAK read -r -d '' -a segments <<<"$1"
  (( ${#segments[@]} )) || return 1
  (( ${#segments[@]} > MAX_SEGMENT )) && guard_deny "$event" "$OVERRUN"
  for segment in "${segments[@]}"; do
    IFS=$HEAD_BREAK read -r head args <<<"$segment"
    [[ -z $head || -z $args && $head == [0-9] ]] && continue
    [[ $READERS == *" $head "* ]] || return 1
  done
  return 0
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
    shell_reads_queue "$text" && guard_allow "$event"
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
