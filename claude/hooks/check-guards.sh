#!/usr/bin/env bash
# Feeds each guard the JSON its CLI sends and prints one line per case: Claude Code and Codex send
# PreToolUse (Codex's shell is Bash, its edits apply_patch), Gemini CLI sends BeforeTool
# (run_shell_command, write_file, replace). `decision` reads either deny shape; `shape` names which
# shape came back, or `silent` for no output and `empty-json` for {}.
set -u
H=${HOOKS:-$HOME/.dotfiles/claude/hooks}
# GUARD_BASH runs the guards under that interpreter instead of their shebang; the last line reruns
# every case under macOS's bash 3.2, which `env bash` resolves to when Homebrew's is not on PATH.
guard() { ${GUARD_BASH:-} "$H/$1"; }
decision() { local out; out=$(cat); [[ -z $out ]] && echo allow || jq -r '.decision // .hookSpecificOutput.permissionDecision // "allow"' <<<"$out" 2>/dev/null; }
shape() { local out; out=$(cat); [[ -z $out ]] && echo silent || jq -r 'if .decision then "gemini" elif .hookSpecificOutput then "claude" else "empty-json" end' <<<"$out" 2>/dev/null; }
fail=0
case_() { # name expected actual
  if [[ $2 == "$3" ]]; then echo "PASS $1"; else echo "FAIL $1: expected $2, got '$3'"; fail=1; fi
}
payload() { # event tool key value [cwd]
  jq -cn --arg e "$1" --arg t "$2" --arg k "$3" --arg v "$4" --arg c "${5:-}" '{hook_event_name:$e,tool_name:$t,tool_input:{($k):$v},cwd:$c}'
}
qv() { payload PreToolUse "$1" "$2" "$3" "${4:-}" | guard guard-queue-views.sh | decision; }
gv() { payload BeforeTool "$1" "$2" "$3" "${4:-}" | guard guard-queue-views.sh | decision; }
mg() { payload PreToolUse Bash command "$1" | guard guard-merge.sh | decision; }
gm() { payload BeforeTool run_shell_command command "$1" | guard guard-merge.sh | decision; }
patch() { printf '*** Begin Patch\n*** %s File: %s\n@@\n-a\n+b\n*** End Patch\n' "$1" "$2"; }
ipatch() { printf '*** Begin Patch\n  *** %s File: %s\n@@\n-a\n+b\n*** End Patch\n' "$1" "$2"; }
mpatch() { printf '*** Begin Patch\n*** Update File: %s\n*** Move to: %s\n@@\n-a\n+b\n*** End Patch\n' "$1" "$2"; }
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
case_ "dotdot past root"              deny  "$(qv Edit file_path "/../../$T/Tribemap/Queue.md")"
case_ "edit relative, open session"   deny  "$(qv Edit file_path "vault-queues/ClaudeOS/Queue.md")"
# --- codex: PreToolUse, shell as Bash, edits as apply_patch with the patch in tool_input.command
case_ "codex apply_patch update authority, open session"   allow "$(qv apply_patch command "$(patch Update "$T/ClaudeOS/Queue.md")")"
case_ "codex apply_patch relative authority, open session" allow "$(qv apply_patch command "$(patch Update ClaudeOS/Queue.md)" "$T")"
case_ "codex apply_patch relative authority, no session"   deny  "$(qv apply_patch command "$(patch Update Tribemap/Queue.md)" "$T")"
case_ "codex apply_patch delete authority, open session"   deny  "$(qv apply_patch command "$(patch Delete "$T/ClaudeOS/Queue.md")")"
case_ "codex apply_patch two files, one without session"   deny  "$(qv apply_patch command "$(patch Update "$T/ClaudeOS/Queue.md")$(patch Update "$T/Tribemap/Queue.md")")"
case_ "codex apply_patch indented header, no session"      deny  "$(qv apply_patch command "$(ipatch Update Tribemap/Queue.md)" "$T")"
case_ "codex apply_patch indented header, open session"    allow "$(qv apply_patch command "$(ipatch Update "$T/ClaudeOS/Queue.md")")"
case_ "codex apply_patch move onto authority, open session" deny "$(qv apply_patch command "$(mpatch README.md ClaudeOS/Queue.md)" "$T")"
case_ "codex apply_patch move authority away, open session" deny "$(qv apply_patch command "$(mpatch ClaudeOS/Queue.md ClaudeOS/old.md)" "$T")"
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
C=$HOME/code/claudeos
I="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain/projects/ClaudeOS"
case_ "bash sed bare name, cwd in view"       deny  "$(qv Bash command "sed -i '' 's/a/b/' Queue.md" "$V")"
case_ "bash append bare name, cwd in view"    deny  "$(qv Bash command "echo x >> Queue.md" "$V")"
case_ "bash append unspaced, cwd in view"     deny  "$(qv Bash command "echo x >>Queue.md" "$V")"
case_ "bash dot-slash name, cwd in view"      deny  "$(qv Bash command "cat ./Queue.md" "$V")"
case_ "bash dotdot name, cwd under view"      deny  "$(qv Bash command "cat ../Queue.md" "$V/plans")"
case_ "bash bare name, cwd in icloud view"    deny  "$(qv Bash command "cat Queue.md" "$I")"
case_ "bash project name, cwd authority root" deny  "$(qv Bash command "sed -i '' 's/a/b/' ClaudeOS/Queue.md" "${Q%/*}")"
case_ "bash cd into view"                     deny  "$(qv Bash command "cd $V && sed -i '' 's/a/b/' Queue.md" "$C")"
case_ "bash cd into view, no cwd"             deny  "$(qv Bash command "cd $V && cat Queue.md")"
case_ "bash cd chain into view"               deny  "$(qv Bash command "cd ~/obsidian/SecondBrain && cd projects/ClaudeOS && cat Queue.md" "$C")"
case_ "bash cd semicolon chain into view"     deny  "$(qv Bash command "cd ~/obsidian/SecondBrain;cd projects/ClaudeOS;cat Queue.md" "$C")"
case_ "bash cd quoted icloud view"            deny  "$(qv Bash command "cd '$I' && cat Queue.md" "$C")"
case_ "bash cd double-quoted icloud view"     deny  "$(qv Bash command "cd \"$I\" && cat Queue.md" "$C")"
case_ "bash cd in subshell into authority"    deny  "$(qv Bash command "(cd $Q; sed -i 's/a/b/' Queue.md)" "$C")"
case_ "bash unbalanced quote, cwd in view"    deny  "$(qv Bash command "echo 'x >> Queue.md" "$V")"
case_ "bash empty command, cwd in view"       allow "$(qv Bash command "" "$V")"
case_ "bash long command, bare name elsewhere" allow "$(qv Bash command "echo $(head -c 40000 /dev/zero | tr '\0' a); cat Queue.md" "$C")"
case_ "bash bare name elsewhere"              allow "$(qv Bash command "cat Queue.md" "$C/testdata")"
case_ "bash bare name, no cwd"                allow "$(qv Bash command "cat Queue.md")"
case_ "bash grep pattern elsewhere"           allow "$(qv Bash command "grep -rn Queue.md internal" "$C")"
case_ "bash cd elsewhere"                     allow "$(qv Bash command "cd internal/queue && cat testdata/Queue.md" "$C")"
case_ "bash other basename, cwd in view"      allow "$(qv Bash command "cat OldQueue.md" "$V")"
case_ "bash grep pattern, cwd vault root"     allow "$(qv Bash command "grep -n Queue.md CLAUDE.md" "$HOME/obsidian/SecondBrain")"
case_ "queue guard bad input"  allow "$(printf 'garbage' | guard guard-queue-views.sh | decision)"
case_ "codex bash sed authority"             deny  "$(qv Bash command "sed -i 's/a/b/' $Q/Queue.md")"
case_ "codex apply_patch update view"        deny  "$(qv apply_patch command "$(patch Update "$V/Queue.md")")"
case_ "codex apply_patch add relative view"  deny  "$(qv apply_patch command "$(patch Add projects/ClaudeOS/Queue.md)" "$HOME/obsidian/SecondBrain")"
case_ "codex apply_patch body mentions view" deny  "$(qv apply_patch command "$(printf '*** Begin Patch\n*** Update File: README.md\n@@\n-a\n+see projects/ClaudeOS/Queue.md\n*** End Patch\n')" "$HOME/code/claudeos")"
case_ "codex apply_patch unrelated"          allow "$(qv apply_patch command "$(patch Update README.md)" "$HOME/code/claudeos")"
case_ "codex apply_patch move unrelated"     allow "$(qv apply_patch command "$(mpatch README.md docs/README.md)" "$HOME/code/claudeos")"
case_ "codex apply_patch context mentions view"      allow "$(qv apply_patch command "$(printf '*** Begin Patch\n*** Update File: README.md\n@@\n see projects/ClaudeOS/Queue.md\n-a\n+b\n*** End Patch\n')" "$HOME/code/claudeos")"
case_ "codex apply_patch removed line mentions view" allow "$(qv apply_patch command "$(printf '*** Begin Patch\n*** Update File: README.md\n@@\n-see projects/ClaudeOS/Queue.md\n+b\n*** End Patch\n')" "$HOME/code/claudeos")"
case_ "codex apply_patch relative authority, no cwd" deny  "$(qv apply_patch command "$(patch Update ClaudeOS/Queue.md)")"
case_ "codex apply_patch relative unrelated, no cwd" allow "$(qv apply_patch command "$(patch Update README.md)")"
case_ "gemini replace relative authority, no cwd"    deny  "$(gv replace file_path ClaudeOS/Queue.md)"
case_ "gemini write_file view"     deny  "$(gv write_file file_path "$V/Queue.md")"
case_ "gemini shell cat view"      deny  "$(gv run_shell_command command "cat $V/Queue.md")"
case_ "gemini shell unrelated"     allow "$(gv run_shell_command command "cat README.md")"
case_ "gemini shell bare name, cwd in view" deny  "$(gv run_shell_command command "sed -i 's/a/b/' Queue.md" "$V")"
case_ "gemini shell cd into view"           deny  "$(gv run_shell_command command "cd $V && cat Queue.md" "$C")"
case_ "gemini shell bare name elsewhere"    allow "$(gv run_shell_command command "cat Queue.md" "$C")"
case_ "gemini queue deny shape"    gemini     "$(payload BeforeTool write_file file_path "$V/Queue.md" | guard guard-queue-views.sh | shape)"
case_ "gemini queue allow shape"   empty-json "$(payload BeforeTool write_file file_path "$V/Inbox.md" | guard guard-queue-views.sh | shape)"
case_ "claude queue deny shape"    claude     "$(payload PreToolUse Write file_path "$V/Queue.md" | guard guard-queue-views.sh | shape)"
case_ "claude queue allow shape"   silent     "$(payload PreToolUse Write file_path "$V/Inbox.md" | guard guard-queue-views.sh | shape)"
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
case_ "gh by absolute path"    deny  "$(mg "/opt/homebrew/bin/gh pr merge 12")"
case_ "gh by relative path"    deny  "$(mg "./bin/gh pr merge 12")"
case_ "gh quoted"              deny  "$(mg '"gh" pr merge 12')"
case_ "gh by which"            deny  "$(mg '$(which gh) pr merge 12')"
case_ "gh by backtick which"   deny  "$(mg '`which gh` pr merge 12')"
case_ "gh pr merge, semicolon" deny  "$(mg "gh pr merge; echo done")"
case_ "gh pr merge, subshell"  deny  "$(mg "(cd repo && gh pr merge)")"
case_ "gh pr merge, piped"     deny  "$(mg "gh pr merge|tee log")"
case_ "gh pr merge --help"     allow "$(mg "gh pr merge --help")"
case_ "help, then a merge"     deny  "$(mg "gh pr merge --help; gh pr merge 12")"
case_ "help, merge on line 2"  deny  "$(mg "$(printf 'gh pr merge --help\ngh pr merge 12')")"
case_ "help piped"             deny  "$(mg "gh pr merge --help | head")"
case_ "help beside a number"   deny  "$(mg "gh pr merge 12 --help")"
case_ "help by absolute path"  deny  "$(mg "/opt/homebrew/bin/gh pr merge --help")"
case_ "gh help pr merge"       deny  "$(mg "gh help pr merge")"
case_ "gh search merge-queue"  allow "$(mg "gh issue list --search 'pr merge-queue'")"
case_ "merge guard bad input"  allow "$(printf 'garbage' | guard guard-merge.sh | decision)"
case_ "gemini gh pr merge"         deny       "$(gm "gh pr merge 12")"
case_ "gemini gh -R pr merge"      deny       "$(gm "gh -R pablobfonseca/claudeos pr merge 12 --squash")"
case_ "gemini gh pr view"          allow      "$(gm "gh pr view 12")"
case_ "gemini gh by absolute path" deny       "$(gm "/opt/homebrew/bin/gh pr merge 12")"
case_ "gemini gh by relative path" deny       "$(gm "./bin/gh pr merge 12")"
case_ "gemini gh pr merge --help"  allow      "$(gm "gh pr merge --help")"
case_ "gemini merge help shape"    empty-json "$(payload BeforeTool run_shell_command command "gh pr merge --help" | guard guard-merge.sh | shape)"
case_ "gemini merge deny shape"    gemini     "$(payload BeforeTool run_shell_command command "gh pr merge 12" | guard guard-merge.sh | shape)"
case_ "gemini merge allow shape"   empty-json "$(payload BeforeTool run_shell_command command "gh pr view 12" | guard guard-merge.sh | shape)"
case_ "claude merge deny shape"    claude     "$(payload PreToolUse Bash command "gh pr merge 12" | guard guard-merge.sh | shape)"
case_ "claude merge allow shape"   silent     "$(payload PreToolUse Bash command "gh pr view 12" | guard guard-merge.sh | shape)"
case_ "merge guard bad input, gemini shape" silent "$(printf 'garbage' | guard guard-merge.sh | shape)"
if [[ -z ${GUARD_BASH:-} && -x /bin/bash ]]; then
  GUARD_BASH=/bin/bash "$0" | sed "s|^|[/bin/bash] |"
  (( PIPESTATUS[0] == 0 )) || fail=1
fi
exit $fail
