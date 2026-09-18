#!/usr/bin/env bash
# PreToolUse/Write|Edit|Bash: Queue.md is written by `claudeos queue` only. Refuses Edit and Write on the
# vault's generated views and on the vault-queues authority, and any Bash command that names either;
# reads go through `claudeos queue dump` and `claudeos queue find`. The one exception is Edit on the authority
# while `claudeos queue edit <project> begin` has an open session (<repo>/.git/queue-tool-edit/<project>, the
# marker path the Python queue-tool used, kept by the port).
set -uo pipefail

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

input=$(cat) || exit 0
tool=$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null) || exit 0
case "$tool" in
  Bash) target=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null) ;;
  *)    target=$(clean_path "$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null)") ;;
esac

[[ $target =~ (SecondBrain/projects|vault-queues|(^|[^[:alnum:]_/.-])projects)/[^/[:space:]]+/Queue\.md ]] || exit 0

if [[ $tool == Edit && $target == /*/Queue.md ]]; then
  project_dir=${target%/Queue.md}
  [[ -f ${project_dir%/*}/.git/queue-tool-edit/${project_dir##*/} ]] && exit 0
fi

cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Queue.md is written by claudeos queue only: the vault's projects/<P>/Queue.md is a GENERATED READ-ONLY VIEW, overwritten on the next queue write, and the vault-queues copy is the authority it regenerates from, where a hand edit leaves the repo dirty and every later queue write refused. Use the tool: claudeos queue state|lane|mark|add|stamp <project> <qN> ... for single-line changes, `claudeos queue edit <project> begin` then `claudeos queue edit <project> commit -m \"...\"` for free-form grooming, and claudeos queue dump|find <project> to read. Run `claudeos queue --help` for syntax."}}
JSON
exit 0
