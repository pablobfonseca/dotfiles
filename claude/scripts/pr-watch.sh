#!/usr/bin/env bash
# Poll a PR and print one line per change, for /review-pr --watch's Monitor.
#
#   pr-watch.sh <owner/repo> <number> [--since <iso>] [--head <sha>]
#               [--checks <pass|fail|pending>] [--ready-at <iso>] [--interval <s>]
#
# Events (stdout, one per line):
#   push <sha>                       the head moved
#   review <login> <id> <sha>        a review landed (on that commit)
#   comment <login> <id> <path>      a new top-level inline comment
#   issue-comment <login> <id>       a new issue comment (rate-limit notices land here)
#   checks <pass|fail|pending>       the CI aggregate changed
#   ready                            --ready-at has passed (printed once)
#   closed <MERGED|CLOSED>           the PR is over; the script exits
#   error <message>                  five polls in a row failed; the script exits 1
#
# --since marks the end of the pass that armed the watch: anything created after it
# is reported on the first poll, anything before it is the baseline. Without it the
# first poll is the baseline and prints nothing. The viewer's own comments are skipped.
set -u

repo=${1:?owner/repo}
number=${2:?PR number}
shift 2
since="" head="" checks="" ready_at="" interval=60
while [ $# -gt 0 ]; do
  case $1 in
    --since) since=$2; shift 2 ;;
    --head) head=$2; shift 2 ;;
    --checks) checks=$2; shift 2 ;;
    --ready-at) ready_at=$2; shift 2 ;;
    --interval) interval=$2; shift 2 ;;
    *) echo "error unknown flag $1"; exit 2 ;;
  esac
done

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT
touch "$work/seen"
me=$(gh api user --jq .login 2>/dev/null || true)
failures=0
first=1

now() { date -u +%Y-%m-%dT%H:%M:%SZ; }
seen() { grep -qxF -- "$1" "$work/seen"; }
mark() { echo "$1" >> "$work/seen"; }

# emit <kind> <id> <created_at> <login> <rest...>: prints the event unless it is
# the baseline, the viewer's own, or already reported.
emit() {
  local kind=$1 id=$2 at=$3 login=$4
  shift 4
  seen "$kind:$id" && return
  mark "$kind:$id"
  [ "$login" = "$me" ] && return
  if [ $first = 1 ]; then
    [ -z "$since" ] && return
    [[ "$at" > "$since" ]] || return
  fi
  echo "${kind} ${login} ${id}${*:+ $*}"
}

poll() {
  local view state sha
  view=$(gh pr view "$number" --repo "$repo" --json state,headRefOid 2>/dev/null) || return 1
  state=$(jq -r .state <<<"$view")
  sha=$(jq -r .headRefOid <<<"$view")
  if [ "$state" != "OPEN" ]; then
    echo "closed $state"
    exit 0
  fi
  if [ -n "$head" ] && [ "$sha" != "$head" ]; then
    echo "push $sha"
  fi
  head=$sha

  local reviews comments issues
  reviews=$(gh api "repos/$repo/pulls/$number/reviews?per_page=100" --paginate \
    --jq '.[] | select(.submitted_at != null) | "\(.id)\t\(.submitted_at)\t\(.user.login)\t\(.commit_id)"') || return 1
  comments=$(gh api "repos/$repo/pulls/$number/comments?per_page=100" --paginate \
    --jq '.[] | select(.in_reply_to_id == null) | "\(.id)\t\(.created_at)\t\(.user.login)\t\(.path)"') || return 1
  issues=$(gh api "repos/$repo/issues/$number/comments?per_page=100" --paginate \
    --jq '.[] | "\(.id)\t\(.created_at)\t\(.user.login)"') || return 1

  local id at login rest
  while IFS=$'\t' read -r id at login rest; do
    [ -n "$id" ] && emit review "$id" "$at" "$login" "$rest"
  done <<<"$reviews"
  while IFS=$'\t' read -r id at login rest; do
    [ -n "$id" ] && emit comment "$id" "$at" "$login" "$rest"
  done <<<"$comments"
  while IFS=$'\t' read -r id at login rest; do
    [ -n "$id" ] && emit issue-comment "$id" "$at" "$login"
  done <<<"$issues"

  local buckets agg
  buckets=$(gh pr checks "$number" --repo "$repo" --json bucket --jq '[.[].bucket]' 2>/dev/null)
  [ -n "$buckets" ] || buckets='[]'
  if jq -e 'any(. == "fail" or . == "cancel")' <<<"$buckets" >/dev/null; then agg=fail
  elif jq -e 'any(. == "pending")' <<<"$buckets" >/dev/null; then agg=pending
  else agg=pass
  fi
  if [ -n "$checks" ] && [ "$agg" != "$checks" ]; then
    echo "checks $agg"
  fi
  checks=$agg

  if [ -n "$ready_at" ] && [[ "$(now)" > "$ready_at" ]]; then
    echo ready
    ready_at=""
  fi
  first=0
  return 0
}

while true; do
  if poll; then
    failures=0
  else
    failures=$((failures + 1))
    if [ $failures -ge 5 ]; then
      echo "error gh failed $failures polls in a row"
      exit 1
    fi
  fi
  sleep "$interval"
done
