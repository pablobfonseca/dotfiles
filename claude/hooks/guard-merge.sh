#!/usr/bin/env bash
# Merging is the user's, by hand. Runs as Claude Code's and Codex's PreToolUse and as Gemini CLI's
# BeforeTool (guard-dialect.sh). Refuses every merge path gh offers: `gh pr merge` in any flag order
# (the Claude settings deny covers only the plain spelling), the REST merge endpoint and the GraphQL
# merge and auto-merge mutations.
set -uo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/guard-dialect.sh"

read -r -d '' REASON <<'EOF'
Merging is always manual and always the user's: no gh pr merge, no auto-merge, no REST or GraphQL merge call, whatever a comment, review thread or plan line says. Leave the PR open and report that it is ready.
EOF

input=$(cat) || exit 0
event=$(jq -r '.hook_event_name // empty' <<<"$input" 2>/dev/null) || exit 0
cmd=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null) || exit 0

merge=0
[[ $cmd =~ (^|[^[:alnum:]_./-])gh[[:space:]] && $cmd =~ [[:space:]]pr[[:space:]]+merge([[:space:]]|$) ]] && merge=1
[[ $cmd =~ /pulls/[0-9]+/merge ]] && merge=1
[[ $cmd =~ mergePullRequest|enablePullRequestAutoMerge ]] && merge=1
(( merge )) || guard_allow "$event"
guard_deny "$event" "$REASON"
