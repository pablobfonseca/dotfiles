#!/usr/bin/env bash
# Feeds each guard the JSON Claude Code sends and prints one line per case.
set -u
H=${HOOKS:-$HOME/.dotfiles/claude/hooks}
decision() { local out; out=$(cat); [[ -z $out ]] && echo allow || jq -r '.hookSpecificOutput.permissionDecision' <<<"$out" 2>/dev/null; }
case_() { # name expected actual
  if [[ $2 == "$3" ]]; then echo "PASS $1"; else echo "FAIL $1: expected $2, got '$3'"; fi
}
qv() { jq -cn --arg t "$1" --arg k "$2" --arg v "$3" '{tool_name:$t,tool_input:{($k):$v}}' | "$H/guard-queue-views.sh" | decision; }
mg() { jq -cn --arg c "$1" '{tool_name:"Bash",tool_input:{command:$c}}' | "$H/guard-merge.sh" | decision; }
V=$HOME/obsidian/SecondBrain/projects/ClaudeOS
Q=$HOME/.local/share/vault-queues/ClaudeOS
case_ "edit vault view"        deny  "$(qv Edit file_path "$V/Queue.md")"
case_ "write vault view"       deny  "$(qv Write file_path "$V/Queue.md")"
case_ "write authority"        deny  "$(qv Write file_path "$Q/Queue.md")"
T=$(mktemp -d)/vault-queues
mkdir -p "$T/.git/queue-tool-edit" "$T/ClaudeOS" "$T/Tribemap"
touch "$T/.git/queue-tool-edit/ClaudeOS"
case_ "edit authority, no session"    deny  "$(qv Edit file_path "$T/Tribemap/Queue.md")"
case_ "edit authority, open session"  allow "$(qv Edit file_path "$T/ClaudeOS/Queue.md")"
case_ "write authority, open session" deny  "$(qv Write file_path "$T/ClaudeOS/Queue.md")"
case_ "bash authority, open session"  deny  "$(qv Bash command "sed -i '' 's/a/b/' $T/ClaudeOS/Queue.md")"
case_ "edit session via dotdot"       deny  "$(qv Edit file_path "$T/ClaudeOS/../Tribemap/Queue.md")"
case_ "edit dotdot into session"      allow "$(qv Edit file_path "$T/Tribemap/../ClaudeOS/Queue.md")"
case_ "write view via dot"            deny  "$(qv Write file_path "$V/./Queue.md")"
case_ "write view via dotdot"         deny  "$(qv Write file_path "$V/plans/../Queue.md")"
case_ "dotdot past root"              deny  "$(qv Edit file_path "/../../$Q/Queue.md")"
case_ "edit relative, open session"   deny  "$(qv Edit file_path "vault-queues/ClaudeOS/Queue.md")"
rm -rf "${T%/vault-queues}"
case_ "bash sed authority"     deny  "$(qv Bash command "sed -i 's/a/b/' $Q/Queue.md")"
case_ "bash heredoc view"      deny  "$(qv Bash command "cat > $V/Queue.md <<'X'")"
case_ "bash cat relative view" deny  "$(qv Bash command "cat projects/ClaudeOS/Queue.md")"
case_ "bash icloud view"       deny  "$(qv Bash command "sed -i '' 's/a/b/' '$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain/projects/ClaudeOS/Queue.md'")"
case_ "edit inbox"             allow "$(qv Edit file_path "$V/Inbox.md")"
case_ "edit a plan"            allow "$(qv Edit file_path "$V/plans/2026-09-16-mechanical-rules.md")"
case_ "bash queue-tool dump"   allow "$(qv Bash command "queue-tool dump ClaudeOS")"
case_ "bash grep docs"         allow "$(qv Bash command "grep -n Queue.md ~/obsidian/SecondBrain/CLAUDE.md")"
case_ "bash unrelated"         allow "$(qv Bash command "cat README.md")"
case_ "queue guard bad input"  allow "$(printf 'garbage' | "$H/guard-queue-views.sh" | decision)"
case_ "gh pr merge"            deny  "$(mg "gh pr merge 12")"
case_ "gh -R pr merge"         deny  "$(mg "gh -R pablobfonseca/claudeos pr merge 12 --squash")"
case_ "gh pr merge --auto"     deny  "$(mg "gh pr merge --auto 12")"
case_ "rest merge"             deny  "$(mg "gh api -X PUT repos/o/r/pulls/12/merge")"
case_ "graphql merge"          deny  "$(mg 'gh api graphql -f query="mutation { mergePullRequest(input:{pullRequestId:\"x\"}) { clientMutationId } }"')"
case_ "graphql auto-merge"     deny  "$(mg 'gh api graphql -f query="mutation { enablePullRequestAutoMerge(input:{pullRequestId:\"x\"}) { clientMutationId } }"')"
case_ "gh pr create"           allow "$(mg "gh pr create --assignee @me")"
case_ "gh pr view"             allow "$(mg "gh pr view 12")"
case_ "git merge local"        allow "$(mg "git merge origin/master")"
case_ "gh pr list search"      allow "$(mg "gh pr list --search merge")"
case_ "merge guard bad input"  allow "$(printf 'garbage' | "$H/guard-merge.sh" | decision)"
