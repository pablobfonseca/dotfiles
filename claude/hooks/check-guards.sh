#!/usr/bin/env bash
# Feeds each guard the JSON its CLI sends and prints one line per case: Claude Code and Codex send
# PreToolUse (Codex's shell is Bash, its edits apply_patch), Gemini CLI sends BeforeTool
# (run_shell_command, write_file, replace). `decision` reads either deny shape; `shape` names which
# shape came back, or `silent` for no output and `empty-json` for {}.
set -u
H=${HOOKS:-$HOME/.dotfiles/claude/hooks}
decision() { local out; out=$(cat); [[ -z $out ]] && echo allow || jq -r '.decision // .hookSpecificOutput.permissionDecision // "allow"' <<<"$out" 2>/dev/null; }
shape() { local out; out=$(cat); [[ -z $out ]] && echo silent || jq -r 'if .decision then "gemini" elif .hookSpecificOutput then "claude" else "empty-json" end' <<<"$out" 2>/dev/null; }
case_() { # name expected actual
  if [[ $2 == "$3" ]]; then echo "PASS $1"; else echo "FAIL $1: expected $2, got '$3'"; fi
}
payload() { # event tool key value [cwd]
  jq -cn --arg e "$1" --arg t "$2" --arg k "$3" --arg v "$4" --arg c "${5:-}" '{hook_event_name:$e,tool_name:$t,tool_input:{($k):$v},cwd:$c}'
}
qv() { payload PreToolUse "$1" "$2" "$3" "${4:-}" | "$H/guard-queue-views.sh" | decision; }
gv() { payload BeforeTool "$1" "$2" "$3" "${4:-}" | "$H/guard-queue-views.sh" | decision; }
mg() { payload PreToolUse Bash command "$1" | "$H/guard-merge.sh" | decision; }
gm() { payload BeforeTool run_shell_command command "$1" | "$H/guard-merge.sh" | decision; }
patch() { printf '*** Begin Patch\n*** %s File: %s\n@@\n-a\n+b\n*** End Patch\n' "$1" "$2"; }
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
# --- codex: PreToolUse, shell as Bash, edits as apply_patch with the patch in tool_input.command
case_ "codex apply_patch update authority, open session"   allow "$(qv apply_patch command "$(patch Update "$T/ClaudeOS/Queue.md")")"
case_ "codex apply_patch relative authority, open session" allow "$(qv apply_patch command "$(patch Update ClaudeOS/Queue.md)" "$T")"
case_ "codex apply_patch relative authority, no session"   deny  "$(qv apply_patch command "$(patch Update Tribemap/Queue.md)" "$T")"
case_ "codex apply_patch delete authority, open session"   deny  "$(qv apply_patch command "$(patch Delete "$T/ClaudeOS/Queue.md")")"
case_ "codex apply_patch two files, one without session"   deny  "$(qv apply_patch command "$(patch Update "$T/ClaudeOS/Queue.md")$(patch Update "$T/Tribemap/Queue.md")")"
# --- gemini: BeforeTool, replace and write_file carry file_path, run_shell_command carries command
case_ "gemini replace authority, open session"          allow "$(gv replace file_path "$T/ClaudeOS/Queue.md")"
case_ "gemini replace relative authority, open session" allow "$(gv replace file_path ClaudeOS/Queue.md "$T")"
case_ "gemini replace relative authority, no session"   deny  "$(gv replace file_path Tribemap/Queue.md "$T")"
case_ "gemini write_file authority, open session"       deny  "$(gv write_file file_path "$T/ClaudeOS/Queue.md")"
rm -rf "${T%/vault-queues}"
case_ "bash sed authority"     deny  "$(qv Bash command "sed -i 's/a/b/' $Q/Queue.md")"
case_ "bash heredoc view"      deny  "$(qv Bash command "cat > $V/Queue.md <<'X'")"
case_ "bash cat relative view" deny  "$(qv Bash command "cat projects/ClaudeOS/Queue.md")"
case_ "bash icloud view"       deny  "$(qv Bash command "sed -i '' 's/a/b/' '$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain/projects/ClaudeOS/Queue.md'")"
case_ "edit inbox"             allow "$(qv Edit file_path "$V/Inbox.md")"
case_ "edit a plan"            allow "$(qv Edit file_path "$V/plans/2026-09-16-mechanical-rules.md")"
case_ "bash queue dump"        allow "$(qv Bash command "claudeos queue dump ClaudeOS")"
case_ "bash grep docs"         allow "$(qv Bash command "grep -n Queue.md ~/obsidian/SecondBrain/CLAUDE.md")"
case_ "bash unrelated"         allow "$(qv Bash command "cat README.md")"
case_ "queue guard bad input"  allow "$(printf 'garbage' | "$H/guard-queue-views.sh" | decision)"
case_ "codex bash sed authority"             deny  "$(qv Bash command "sed -i 's/a/b/' $Q/Queue.md")"
case_ "codex apply_patch update view"        deny  "$(qv apply_patch command "$(patch Update "$V/Queue.md")")"
case_ "codex apply_patch add relative view"  deny  "$(qv apply_patch command "$(patch Add projects/ClaudeOS/Queue.md)" "$HOME/obsidian/SecondBrain")"
case_ "codex apply_patch body mentions view" deny  "$(qv apply_patch command "$(printf '*** Begin Patch\n*** Update File: README.md\n@@\n-a\n+see projects/ClaudeOS/Queue.md\n*** End Patch\n')" "$HOME/code/claudeos")"
case_ "codex apply_patch unrelated"          allow "$(qv apply_patch command "$(patch Update README.md)" "$HOME/code/claudeos")"
case_ "gemini write_file view"     deny  "$(gv write_file file_path "$V/Queue.md")"
case_ "gemini shell cat view"      deny  "$(gv run_shell_command command "cat $V/Queue.md")"
case_ "gemini shell unrelated"     allow "$(gv run_shell_command command "cat README.md")"
case_ "gemini queue deny shape"    gemini     "$(payload BeforeTool write_file file_path "$V/Queue.md" | "$H/guard-queue-views.sh" | shape)"
case_ "gemini queue allow shape"   empty-json "$(payload BeforeTool write_file file_path "$V/Inbox.md" | "$H/guard-queue-views.sh" | shape)"
case_ "claude queue deny shape"    claude     "$(payload PreToolUse Write file_path "$V/Queue.md" | "$H/guard-queue-views.sh" | shape)"
case_ "claude queue allow shape"   silent     "$(payload PreToolUse Write file_path "$V/Inbox.md" | "$H/guard-queue-views.sh" | shape)"
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
case_ "gemini gh pr merge"         deny       "$(gm "gh pr merge 12")"
case_ "gemini gh -R pr merge"      deny       "$(gm "gh -R pablobfonseca/claudeos pr merge 12 --squash")"
case_ "gemini gh pr view"          allow      "$(gm "gh pr view 12")"
case_ "gemini merge deny shape"    gemini     "$(payload BeforeTool run_shell_command command "gh pr merge 12" | "$H/guard-merge.sh" | shape)"
case_ "gemini merge allow shape"   empty-json "$(payload BeforeTool run_shell_command command "gh pr view 12" | "$H/guard-merge.sh" | shape)"
case_ "claude merge deny shape"    claude     "$(payload PreToolUse Bash command "gh pr merge 12" | "$H/guard-merge.sh" | shape)"
case_ "claude merge allow shape"   silent     "$(payload PreToolUse Bash command "gh pr view 12" | "$H/guard-merge.sh" | shape)"
case_ "merge guard bad input, gemini shape" silent "$(printf 'garbage' | "$H/guard-merge.sh" | shape)"
