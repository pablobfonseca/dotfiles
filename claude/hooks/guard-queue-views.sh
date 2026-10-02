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
# A shell command also names one through a relative Queue.md word that the cwd, or a `cd` target in
# the command (each relative target joined to the one before), places on a guarded path. Variables,
# command substitution and scripts are not followed, and with no cwd and no `cd` a bare Queue.md
# word is allowed: a grep pattern cannot be told from a path.
set -uo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/guard-dialect.sh"

QUEUE_RE='(SecondBrain/projects|vault-queues|(^|[^[:alnum:]_/.-])projects)/[^/[:space:]]+/Queue\.md'
read -r -d '' REASON <<'EOF'
Queue.md is written by claudeos queue only: the vault's projects/<P>/Queue.md is a GENERATED READ-ONLY VIEW, overwritten on the next queue write, and the vault-queues copy is the authority it regenerates from, where a hand edit leaves the repo dirty and every later queue write refused. Use the tool: claudeos queue state|lane|mark|add|stamp <project> <qN> ... for single-line changes, `claudeos queue edit <project> begin` then `claudeos queue edit <project> commit -m "..."` for free-form grooming, and claudeos queue dump|find <project> to read. Run `claudeos queue --help` for syntax.
EOF

clean_path() {
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
  if [[ $1 == /* ]]; then printf '/%s' "${out[*]}"; else printf '%s' "${out[*]}"; fi
}

absolute() { # <path> [base]: a relative path is joined to the base, the payload's cwd unless one is given, if any
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

CD_RE="(^|[;&|(){}[:space:]])cd[[:space:]]+(\"([^\"]*)\"|'([^']*)'|([^;&|()<>[:space:]\"']+))(.*)\$"
# Words are split by IFS and matched by glob: bash 3.2 runs ${var//pattern/ } and ${word##*/} in
# quadratic time, which stalls the hook on a long command.
WORD_BREAK=$' \t\n"\';&|<>()`'

shell_names_queue() { # <command>: a Queue.md word that the cwd, or a `cd` target in the command, places on a guarded one
  [[ $1 == *Queue.md* ]] || return 1
  local rest=$1 base=$cwd bases=("$cwd") words word
  while [[ $rest =~ $CD_RE ]]; do
    rest=${BASH_REMATCH[6]}
    base=$(absolute "${BASH_REMATCH[3]}${BASH_REMATCH[4]}${BASH_REMATCH[5]}" "$base")
    bases+=("$base")
  done
  IFS=$WORD_BREAK read -r -d '' -a words <<<"$1"
  for word in "${words[@]}"; do
    [[ $word == Queue.md || $word == */Queue.md ]] || continue
    for base in "${bases[@]}"; do
      [[ $(absolute "$word" "$base") =~ $QUEUE_RE ]] && return 0
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
    cmd=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)
    [[ $cmd =~ $QUEUE_RE ]] || shell_names_queue "$cmd" || guard_allow "$event"
    guard_deny "$event" "$REASON"
    ;;
  apply_patch)
    patch=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)
    from_queue=
    while IFS= read -r line; do
      header=${line#"${line%%[![:space:]]*}"}
      header=${header%"${header##*[![:space:]]}"}
      if [[ $header =~ ^\*\*\*\ (Update|Add|Delete)\ File:\ (.+)$ ]]; then
        op=${BASH_REMATCH[1]}
        path=$(absolute "${BASH_REMATCH[2]}")
        from_queue=
        is_queue "$path" || continue
        from_queue=1
        [[ $op == Update ]] && session_open "$path" && continue
        guard_deny "$event" "$REASON"
      elif [[ $header =~ ^\*\*\*\ Move\ to:\ (.+)$ ]]; then
        [[ -z $from_queue ]] && ! is_queue "$(absolute "${BASH_REMATCH[1]}")" && continue
        guard_deny "$event" "$REASON"
      elif [[ $line == +* && $line =~ $QUEUE_RE ]]; then
        guard_deny "$event" "$REASON"
      fi
    done <<<"$patch"
    guard_allow "$event"
    ;;
  *)
    file=$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null)
    [[ -n $file ]] || guard_allow "$event"
    target=$(absolute "$file")
    is_queue "$target" || guard_allow "$event"
    case "$tool" in Edit|replace) session_open "$target" && guard_allow "$event" ;; esac
    guard_deny "$event" "$REASON"
    ;;
esac
