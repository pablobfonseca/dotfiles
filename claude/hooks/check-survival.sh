#!/usr/bin/env bash
# Feeds survival-list.sh the payloads Claude Code sends on PreCompact and SessionStart and prints one
# line per case. Everything it reads is a fixture under a temp directory: HOME (so the vault path
# resolves there), a git checkout, transcripts, and a stub `claudeos` first on PATH that answers
# `queue dump` and `queue find` from files and logs its argv.
set -u
H=${HOOKS:-$(cd "$(dirname "$0")" && pwd)}
T=$(mktemp -d) || exit 1
T=$(cd "$T" && pwd -P) || exit 1
hook() { HOME=$T/home PATH=$T/bin:$PATH ${GUARD_BASH:-} "$H/survival-list.sh"; }
fail=0
case_() { # name expected actual
  if [[ $2 == "$3" ]]; then echo "PASS $1"; else echo "FAIL $1: expected '$2', got '$3'"; fail=1; fi
}
has() { grep -qF -- "$1" && echo yes || echo no; }
silent() { local out; out=$(cat); [[ -z $out ]] && echo silent || echo "spoke: $out"; }
payload() { # event transcript [source] [cwd]
  jq -cn --arg e "$1" --arg t "$2" --arg s "${3:-}" --arg c "${4:-$T/repo}" \
    '{session_id:"s",hook_event_name:$e,transcript_path:$t,cwd:$c} + (if $s == "" then {trigger:"auto"} else {source:$s} end)'
}
command_line() { # args
  jq -cn --arg a "$1" '{type:"user",message:{role:"user",content:("<command-message>implement-plan</command-message>\n<command-name>/implement-plan</command-name>\n<command-args>" + $a + "</command-args>")}}'
}
transcript() { # name args...: one /implement-plan entry per argument, between ordinary entries
  local f=$T/$1.jsonl
  shift
  jq -cn '{type:"user",message:{role:"user",content:"hello"}}' >"$f"
  for a in "$@"; do command_line "$a" >>"$f"; done
  jq -cn '{type:"assistant",message:{role:"assistant",content:[{type:"text",text:"ok"}]}}' >>"$f"
  echo "$f"
}
start() { payload SessionStart "$(transcript "$1" "$2")" compact "${3:-}" | hook; }

P=$T/home/obsidian/SecondBrain/projects/Demo/plans
mkdir -p "$P" "$T/bin" "$T/repo/docs/plans" "$T/repo/sub"
git -C "$T/repo" init -q -b q7-demo
git -C "$T/repo" -c user.name=t -c user.email=t@example.com commit -q --allow-empty -m init

F='```'
cat >"$P/full.md" <<EOF
# Demo Implementation Plan

## Stop and ask

- The fixture trigger fires.
- A second trigger, with a fence:

$F
## Not a heading
$F

## File structure

- [ ] a stray box outside any task

### Task 1: first

- [x] **Step 1**
- [x] **Step 2**

### Task 2: second

- [x] **Step 1**
- [ ] **Step 2**

$F$F
### Task 9: inside a fence
- [ ] not a box
$F
still inside the four-backtick fence
$F$F

### Task 3: third

- [ ] **Step 1**

## Self-review

- [ ] not a task
EOF
sed -e 's/- \[ \]/- [x]/' "$P/full.md" >"$P/done.md"
cat >"$P/short.md" <<'EOF'
# Short (^q9) Implementation Plan

**Goal:** one sentence.

**Stop and ask:** the paragraph trigger fires,
on two lines.

### Task 1: only

- [ ] the change
EOF
printf '# No stop\n\n### Task 1: only\n\n- [ ] the change\n' >"$P/nostop.md"
{ printf '# Huge\n\n## Stop and ask\n\n'; for i in $(seq 1 300); do echo "- trigger $i: forty characters of padding here"; done; printf '\n### Task 1: only\n\n- [ ] the change\n'; } >"$P/huge.md"
printf '# Notes\n\nNo tasks here.\n' >"$P/notasks.md"
cp "$P/nostop.md" "$T/repo/docs/plans/old.md"
cp "$P/short.md" "$T/repo/docs/plans/new.md"
touch -t 202601010000 "$T/repo/docs/plans/old.md"

item() { jq -cn --arg id "$1" --arg plan "$2" --arg pr "$3" '{id:$id, plan:(if $plan == "" then null else "[[Demo/plans/" + $plan + "]]" end), pr:(if $pr == "" then null else $pr end)}'; }
{ item q7 full https://github.com/o/r/pull/7; item q8 done ""; item q9 short ""; item q10 nostop ""; item q11 huge ""; item q12 missing ""; item q13 "" ""; item q14 notasks ""; } | jq -cs '{items:.}' >"$T/dump.json"
item q7 full https://github.com/o/r/pull/7 >"$T/find.json"
cat >"$T/bin/claudeos" <<EOF
#!/usr/bin/env bash
echo "\$*" >>"$T/argv.log"
case "\$1 \$2" in
  "queue dump") cat "$T/dump.json" ;;
  "queue find") cat "$T/find.json" ;;
esac
EOF
chmod +x "$T/bin/claudeos"

IMPL=$(transcript impl "Demo | q7")
PLAIN=$T/plain.jsonl
jq -cn '{type:"user",message:{role:"user",content:"fix the bug"}}' >"$PLAIN"
QUOTED=$T/quoted.jsonl
jq -cn '{type:"user",message:{role:"user",content:[{type:"tool_result",content:"<command-message>implement-plan</command-message>\n<command-args>Demo | q7</command-args>"}]}}' >"$QUOTED"
jq -cn '{type:"user",message:{role:"user",content:"see <command-message>implement-plan</command-message> above"}}' >>"$QUOTED"

# --- silence: every session that is not an /implement-plan session, and every event but the two
case_ "garbage stdin"                    silent "$(printf 'garbage' | hook | silent)"
case_ "garbage stdin exits 0"            0      "$(printf 'garbage' | hook >/dev/null 2>&1; echo $?)"
case_ "empty stdin exits 0"              0      "$(hook </dev/null >/dev/null 2>&1; echo $?)"
case_ "other event"                      silent "$(payload Stop "$IMPL" | hook | silent)"
case_ "precompact, plain session"        silent "$(payload PreCompact "$PLAIN" | hook | silent)"
case_ "start, plain session"             silent "$(payload SessionStart "$PLAIN" compact | hook | silent)"
case_ "precompact, tag only quoted"      silent "$(payload PreCompact "$QUOTED" | hook | silent)"
case_ "precompact, transcript missing"   silent "$(payload PreCompact "$T/nope.jsonl" | hook | silent)"
case_ "missing transcript exits 0"       0      "$(payload PreCompact "$T/nope.jsonl" | hook >/dev/null 2>&1; echo $?)"
case_ "start, source startup"            silent "$(payload SessionStart "$IMPL" startup | hook | silent)"
case_ "start, source resume"             silent "$(payload SessionStart "$IMPL" resume | hook | silent)"

# --- PreCompact: instructions to the summariser, no plan lookup
: >"$T/argv.log"
PRE=$(payload PreCompact "$IMPL" | hook)
case_ "precompact names the session"     yes "$(has '/implement-plan Demo | q7 session' <<<"$PRE")"
case_ "precompact asks for decisions"    yes "$(has 'Every decision and local choice' <<<"$PRE")"
case_ "precompact asks for answers"      yes "$(has "the user's answer verbatim" <<<"$PRE")"
case_ "precompact reads no queue"        0   "$(wc -l <"$T/argv.log" | tr -d ' ')"
case_ "precompact exits 0"               0   "$(payload PreCompact "$IMPL" | hook >/dev/null 2>&1; echo $?)"
case_ "precompact, array text content"   yes "$(f=$T/array.jsonl; command_line 'Demo | q7' | jq -c '.message.content |= [{type:"text",text:.}]' >"$f"; payload PreCompact "$f" | hook | has 'Every decision')"
case_ "precompact, no args"              yes "$(payload PreCompact "$(transcript noargs "")" | hook | has 'This is an /implement-plan session.')"

# --- SessionStart(compact), queue form
: >"$T/argv.log"
OUT=$(start q7 "Demo | q7")
case_ "start names the plan"             yes "$(has "Plan: $P/full.md." <<<"$OUT")"
case_ "start counts ticks, skips fences" yes "$(has 'Progress: 1 of 3 tasks ticked. Open task: Task 2: second' <<<"$OUT")"
case_ "start names the branch"           yes "$(has "Branch: q7-demo in $T/repo" <<<"$OUT")"
case_ "start names the PR"               yes "$(has 'PR: https://github.com/o/r/pull/7' <<<"$OUT")"
case_ "start quotes the stop list"       yes "$(has '- The fixture trigger fires.' <<<"$OUT")"
case_ "stop list keeps its fence"        yes "$(has '## Not a heading' <<<"$OUT")"
case_ "stop list ends at next heading"   no  "$(has 'a stray box' <<<"$OUT")"
case_ "qN reads the local dump"          "queue dump Demo --no-pull" "$(cat "$T/argv.log")"
case_ "start exits 0"                    0   "$(payload SessionStart "$IMPL" compact | hook >/dev/null 2>&1; echo $?)"
case_ "caret id"                         yes "$(start caret "Demo | ^q7" | has 'Open task: Task 2: second')"
case_ "bare number id"                   yes "$(start bare "Demo|7" | has 'Open task: Task 2: second')"
: >"$T/argv.log"
case_ "text fragment resolves"           yes "$(start frag "Demo | the first thing" | has 'Open task: Task 2: second')"
case_ "text fragment asks find"          "queue find Demo the first thing" "$(cat "$T/argv.log")"
case_ "last command wins"                yes "$(payload SessionStart "$(transcript two "Demo | q10" "Demo | q7")" compact | hook | has "Plan: $P/full.md.")"
case_ "all ticked"                       yes "$(start q8 "Demo | q8" | has 'Progress: all 3 tasks ticked.')"
case_ "no PR recorded"                   yes "$(start q8b "Demo | q8" | has 'PR: none recorded')"
case_ "short plan stop paragraph"        yes "$(start q9 "Demo | q9" | has 'on two lines.')"
case_ "short plan paragraph ends"        no  "$(start q9b "Demo | q9" | has 'the change')"
case_ "no stop section"                  yes "$(start q10 "Demo | q10" | has 'none in the plan.')"
HUGE=$(start q11 "Demo | q11")
case_ "huge stop list is cut"            yes "$(has '[cut at 6000 characters' <<<"$HUGE")"
case_ "huge output under the cap"        yes "$([[ ${#HUGE} -lt 10000 ]] && echo yes || echo "no: ${#HUGE}")"
case_ "plan file missing"                yes "$(start q12 "Demo | q12" | has "Plan: not found at $P/missing.md.")"
case_ "plan missing keeps the branch"    yes "$(start q12b "Demo | q12" | has 'Branch: q7-demo')"
case_ "line without a plan"              yes "$(start q13 "Demo | q13" | has 'Plan: not found.')"
case_ "unknown id"                       yes "$(start q99 "Demo | q99" | has 'Plan: not found.')"
case_ "plan without boxes"               yes "$(start q14 "Demo | q14" | has 'Progress: the plan has no task checkboxes.')"

# --- SessionStart(compact), path and empty forms, resolved against the checkout root
case_ "path form, relative"              yes "$(start rel "docs/plans/old.md" | has "Plan: $T/repo/docs/plans/old.md.")"
case_ "path form, from a subdirectory"   yes "$(start sub "docs/plans/old.md" "$T/repo/sub" | has "Plan: $T/repo/docs/plans/old.md.")"
case_ "path form, absolute"              yes "$(start abs "$P/short.md" | has "Plan: $P/short.md.")"
case_ "empty form takes the newest"      yes "$(start empty "" | has "Plan: $T/repo/docs/plans/new.md.")"
case_ "outside a checkout"               yes "$(start nogit "Demo | q7" "$T" | has 'Branch: none (detached HEAD or not a git checkout)')"

rm -rf "$T"
if [[ -z ${GUARD_BASH:-} && -x /bin/bash ]]; then
  GUARD_BASH=/bin/bash "$0" | sed "s|^|[/bin/bash] |"
  (( PIPESTATUS[0] == 0 )) || fail=1
fi
exit $fail
