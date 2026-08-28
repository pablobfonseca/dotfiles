#!/usr/bin/env bash
# PreToolUse/Write|Edit: refuse edits to the vault's generated Queue.md views.
# Authority is the vault-queues repo; edits here are overwritten on the next write.
set -uo pipefail

file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null) || exit 0

case "$file" in
  */SecondBrain/projects/*/Queue.md)
    cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"This file is a GENERATED READ-ONLY VIEW of the vault-queues repo. Editing it appears to work and is overwritten on the next queue write. Use the tool instead: queue-tool state|lane|mark|add|stamp <project> <qN> ... for single-line changes, or `queue-tool edit <project> begin` then `queue-tool edit <project> commit -m \"...\"` for free-form grooming. Run `queue-tool --help` for syntax, and see the editing-queues skill."}}
JSON
    ;;
esac

exit 0
