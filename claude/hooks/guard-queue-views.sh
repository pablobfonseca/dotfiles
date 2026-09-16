#!/usr/bin/env bash
# PreToolUse/Write|Edit|Bash: Queue.md is written by queue-tool only. Refuses Edit and Write on the
# vault's generated views and on the vault-queues authority, and any Bash command that names either;
# reads go through `queue-tool dump` and `queue-tool find`.
set -uo pipefail

input=$(cat) || exit 0
tool=$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null) || exit 0
case "$tool" in
  Bash) target=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null) ;;
  *)    target=$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null) ;;
esac

[[ $target =~ (SecondBrain/projects|vault-queues|(^|[^[:alnum:]_/.-])projects)/[^/[:space:]]+/Queue\.md ]] || exit 0

cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Queue.md is written by queue-tool only: the vault's projects/<P>/Queue.md is a GENERATED READ-ONLY VIEW, overwritten on the next queue write, and the vault-queues copy is the authority it regenerates from, where a hand edit leaves the repo dirty and every later queue-tool write refused. Use the tool: queue-tool state|lane|mark|add|stamp <project> <qN> ... for single-line changes, `queue-tool edit <project> begin` then `queue-tool edit <project> commit -m \"...\"` for free-form grooming, and queue-tool dump|find <project> to read. Run `queue-tool --help` for syntax."}}
JSON
exit 0
