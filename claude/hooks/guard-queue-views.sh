#!/usr/bin/env bash
# Queue.md is written by `claudeos queue` only. Runs as Claude Code's and Codex's PreToolUse and as
# Gemini CLI's BeforeTool, told apart by hook_event_name (guard-dialect.sh). Refuses every edit or
# write on the vault's generated views and on the vault-queues authority (Claude's Edit and Write,
# Gemini's replace and write_file, Codex's apply_patch, whose tool_input.command is the patch text) and
# any shell command that names either (Bash, run_shell_command); reads go through `claudeos queue dump`
# and `claudeos queue find`. The one exception is an edit on the authority while
# `claudeos queue edit <project> begin` has an open session (<repo>/.git/queue-tool-edit/<project>, the
# marker path the Python queue-tool used, kept by the port): Edit, replace, and an apply_patch whose
# every Queue.md file header is an `*** Update File:` under one. Relative paths are joined to the
# payload's cwd first; Gemini and Codex send them.
set -uo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/guard-dialect.sh"

QUEUE_RE='(SecondBrain/projects|vault-queues|(^|[^[:alnum:]_/.-])projects)/[^/[:space:]]+/Queue\.md'
REASON=$(cat <<'EOF'
Queue.md is written by claudeos queue only: the vault's projects/<P>/Queue.md is a GENERATED READ-ONLY VIEW, overwritten on the next queue write, and the vault-queues copy is the authority it regenerates from, where a hand edit leaves the repo dirty and every later queue write refused. Use the tool: claudeos queue state|lane|mark|add|stamp <project> <qN> ... for single-line changes, `claudeos queue edit <project> begin` then `claudeos queue edit <project> commit -m "..."` for free-form grooming, and claudeos queue dump|find <project> to read. Run `claudeos queue --help` for syntax.
EOF
)

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

absolute() { # a file_path or a patch header path; a relative one is joined to the payload's cwd
  local p=$1
  [[ $p == /* ]] || p="$cwd/$p"
  clean_path "$p"
}

session_open() { # <absolute .../<project>/Queue.md>: `claudeos queue edit <project> begin` is in flight
  local project_dir=${1%/Queue.md}
  [[ $1 == /*/Queue.md && -f ${project_dir%/*}/.git/queue-tool-edit/${project_dir##*/} ]]
}

input=$(cat) || exit 0
event=$(jq -r '.hook_event_name // empty' <<<"$input" 2>/dev/null) || exit 0
tool=$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null) || exit 0
cwd=$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null) || exit 0

case "$tool" in
  Bash|run_shell_command)
    cmd=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)
    [[ $cmd =~ $QUEUE_RE ]] || guard_allow "$event"
    guard_deny "$event" "$REASON"
    ;;
  apply_patch)
    patch=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)
    while IFS= read -r line; do
      if [[ $line =~ ^\*\*\*\ (Update|Add|Delete)\ File:\ (.+)$ ]]; then
        op=${BASH_REMATCH[1]}
        path=$(absolute "${BASH_REMATCH[2]}")
        [[ $path =~ $QUEUE_RE ]] || continue
        [[ $op == Update ]] && session_open "$path" && continue
        guard_deny "$event" "$REASON"
      elif [[ $line =~ $QUEUE_RE ]]; then
        guard_deny "$event" "$REASON"
      fi
    done <<<"$patch"
    guard_allow "$event"
    ;;
  *)
    file=$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null)
    [[ -n $file ]] || guard_allow "$event"
    target=$(absolute "$file")
    [[ $target =~ $QUEUE_RE ]] || guard_allow "$event"
    case "$tool" in Edit|replace) session_open "$target" && guard_allow "$event" ;; esac
    guard_deny "$event" "$REASON"
    ;;
esac
