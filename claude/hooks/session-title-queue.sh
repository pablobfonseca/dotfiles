#!/usr/bin/env bash
# UserPromptSubmit: title the session after the queue item it is about.
# /fable-plan, /opus-plan and /implement-plan all take "<project> | <item>", so a session
# opened with one becomes "q14" in `claude --resume`, /tasks and the terminal title.
# Claude itself cannot rename a session; only this hook can.
set -uo pipefail

prompt=$(jq -r '.prompt // empty' 2>/dev/null) || exit 0

[[ $prompt =~ ^[[:space:]]*/(fable-plan|opus-plan|implement-plan)[[:space:]]+(.+)$ ]] || exit 0
args=${BASH_REMATCH[2]}

# Plain form (a task description) and implement-plan's path form carry no queue item.
[[ $args == *"|"* ]] || exit 0

trim() { sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'; }
project=$(printf '%s' "${args%%|*}" | trim)
item=$(printf '%s' "${args#*|}" | sed -E 's/--[a-z-]+//g' | trim)

if [[ $item =~ ^\^?q?([0-9]+)$ ]]; then
  id="q${BASH_REMATCH[1]}"
else
  # Issue refs and text fragments only queue-tool can resolve.
  id=$(PATH="$HOME/.dotfiles/scripts:$PATH" queue-tool find "$project" "$item" 2>/dev/null | jq -r '.id // empty')
fi

[[ -n ${id:-} ]] || exit 0
jq -cn --arg t "$id" '{hookSpecificOutput:{hookEventName:"UserPromptSubmit",sessionTitle:$t}}'
