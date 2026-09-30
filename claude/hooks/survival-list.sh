#!/usr/bin/env bash
# PreCompact and SessionStart(compact): what an /implement-plan session must still know after a
# compaction. PreCompact's stdout steers the summary towards what only the conversation holds
# (decisions, answers, work in flight); SessionStart's stdout lands in the new context and carries
# what the disk holds (plan, open task, stop-and-ask list, branch, PR). Silent in every other
# session. Exit 2 on PreCompact blocks the compaction, so every path here ends in exit 0.
set -u

payload=$(cat)
field() { jq -r --arg k "$1" '.[$k] // empty' <<<"$payload" 2>/dev/null; }
event=$(field hook_event_name)
case $event in
  PreCompact) ;;
  SessionStart) [[ $(field source) == compact ]] || exit 0 ;;
  *) exit 0 ;;
esac
transcript=$(field transcript_path)
cwd=$(field cwd)
[[ -r $transcript ]] || exit 0

# The slash command is a user entry whose text opens with the command-message tag. A tool result
# that merely quotes the tag is an array of tool_result blocks and never matches.
TAG='<command-message>implement-plan</command-message>'
found=$(grep -F "$TAG" "$transcript" 2>/dev/null | jq -r --arg tag "$TAG" '
  select(.type == "user")
  | (.message.content | if type == "string" then . else ([.[]? | select(.type == "text") | .text] | join("\n")) end)
  | select(startswith($tag))
  | "IMPL:" + ((capture("<command-args>(?<a>[^<]*)</command-args>") | .a) // "")' 2>/dev/null | tail -n 1)
[[ $found == IMPL:* ]] || exit 0
trim() { sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'; }
args=$(printf '%s' "${found#IMPL:}" | trim)
label="/implement-plan${args:+ $args}"

if [[ $event == PreCompact ]]; then
  cat <<EOF
This is an $label session. The plan file, the branch and the queue line are re-read from disk right after this compaction, so spend the summary on what only this conversation holds. The summary must keep, in full:
1. Every decision and local choice made so far, each with its reason.
2. Every stop-and-ask trigger that fired, the question asked, and the user's answer verbatim.
3. The task in progress: what is done but not committed, which check last failed and with what output, and how many fix attempts were made.
4. The review state when a PR is open: its URL, which review threads were applied, declined or are still pending, and whether the review watch is still running.
5. Every instruction the user gave during this session, verbatim.
EOF
  exit 0
fi

root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || root=$cwd
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
plan='' pr=''
if [[ $args == *"|"* ]]; then
  project=$(printf '%s' "${args%%|*}" | trim)
  item=$(printf '%s' "${args#*|}" | trim)
  if [[ $item =~ ^\^?q?([0-9]+)$ ]]; then
    line=$(claudeos queue dump "$project" --no-pull 2>/dev/null | jq -c --arg id "q${BASH_REMATCH[1]}" '.items[] | select(.id == $id)' 2>/dev/null)
  else
    line=$(claudeos queue find "$project" "$item" 2>/dev/null)
  fi
  link=$(jq -r '.plan // empty' <<<"$line" 2>/dev/null)
  pr=$(jq -r '.pr // empty' <<<"$line" 2>/dev/null)
  link=${link#\[\[}
  link=${link%\]\]}
  [[ -n $link ]] && plan=$HOME/obsidian/SecondBrain/projects/$link.md
elif [[ -n $args ]]; then
  [[ $args == /* ]] && plan=$args || plan=$root/$args
else
  plan=$(ls -t "$root"/docs/plans/*.md 2>/dev/null | head -n 1)
fi

branch_line="Branch: ${branch:-none (detached HEAD or not a git checkout)} in $root"
pr_line="PR: ${pr:-none recorded; after step 4, gh pr view --json url -q .url prints it}"
echo "Compaction survival list for $label, read from disk just now by survival-list.sh."
if [[ -z $plan || ! -r $plan ]]; then
  echo "Plan: not found${plan:+ at $plan}. Resolve it the way /implement-plan does before the next edit."
  echo "$branch_line"
  echo "$pr_line"
  exit 0
fi
echo "Plan: $plan. It is the authority: re-read it before acting on anything the summary says about it."
BRANCH_LINE=$branch_line PR_LINE=$pr_line awk '
  function flush() {
    if (cur != "" && boxes > 0) { total++; if (unticked == 0) ticked++; else if (first == "") first = cur }
    cur = ""
  }
  {
    if (match($0, /^[ \t]*```+/)) {
      n = RLENGTH - index($0, "`") + 1
      if (fence == 0) fence = n
      else if (n >= fence && $0 ~ /^[ \t]*`+[ \t]*$/) fence = 0
      if (stop) body = body $0 "\n"
      next
    }
    if (fence) { if (stop) body = body $0 "\n"; next }
    low = tolower($0)
    if ($0 ~ /^##?#? /) {
      flush()
      stop = 0
      if ($0 ~ /^###? (Task|Phase) [0-9]/) { cur = $0; sub(/^#+ /, "", cur); boxes = 0; unticked = 0 }
      else if (low ~ /^## +stop[ -]and[ -]ask/) stop = 1
      next
    }
    if (stop) body = body $0 "\n"
    else if (low ~ /^\*\*stop and ask:\*\*/) para = 1
    if (para) { if ($0 ~ /^[ \t]*$/) para = 0; else body = body $0 "\n" }
    if (cur != "" && $0 ~ /^[ \t]*- \[ \]/) { boxes++; unticked++ }
    if (cur != "" && $0 ~ /^[ \t]*- \[[xX]\]/) boxes++
  }
  END {
    flush()
    if (total == 0) print "Progress: the plan has no task checkboxes."
    else if (first == "") printf "Progress: all %d tasks ticked. What remains is /implement-plan step 4 (open the PR), 5 (review watch) or 6 (record).\n", total
    else printf "Progress: %d of %d tasks ticked. Open task: %s\n", ticked, total, first
    print ENVIRON["BRANCH_LINE"]
    print ENVIRON["PR_LINE"]
    gsub(/^\n+|\n+$/, "", body)
    if (body == "") body = "none in the plan."
    else if (length(body) > 6000) body = substr(body, 1, 6000) "\n[cut at 6000 characters: read the rest in the plan]"
    print "Stop and ask, the plan\047s own list (the defaults of /implement-plan step 3 apply as well):"
    print body
  }' "$plan"
exit 0
