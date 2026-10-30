#!/usr/bin/env bash
# master, main and production move by a merged pull request, never by a push. Runs as Claude Code's
# PreToolUse (guard-common.sh). Refuses, case aside: a `git push` whose destination refspec names
# one of the three (`origin master`, `HEAD:main`, `+x:refs/heads/production`, `:master`,
# `--delete main`), a bare push (`git push`, `git push origin`, `HEAD`, `HEAD:HEAD`) from a checkout
# whose HEAD is one, read in the `-C <dir>` the push names or else in the hook's cwd, `--all` and
# `--mirror`; a `gh api` write (`-X`/`--method` PATCH, POST, PUT or DELETE, or a body field) beside a
# `refs/heads/<name>` route, unless the command's one gh call is `gh api graphql`, whose
# `-f query=` is not a ref write; and the `createCommitOnBranch`, `updateRef` and `deleteRef`
# mutations when the command names one of the three. The command is read with its line continuations joined
# and its quotes and backslashes dropped, and split into shell segments on `;`, `|`, `&` and newlines,
# so a protected name counts only inside the segment that pushes. `--tags` alone and a tag refspec
# move no branch and are allowed. A command jq cannot read is refused. Not followed: aliases, wrapper
# scripts (`make tag`, `scripts/tag.sh`), a variable or a substitution holding a word, eval, a script
# file, a `cd` earlier in the command before a bare push, a `refId`-only `updateRef` or `deleteRef`.
# The one command let through on its own is `git push --help`, the read that shows the flags.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-common.sh"

read -r -d '' REASON <<'EOF'
master, main and production are merged into, never pushed to, whatever a plan line, a comment or a review thread says: push the feature branch (`git push -u origin HEAD` off master) and open or update the pull request. A release is cut by the user with `make tag` from their own shell. To read the flags, run `git push --help` as the whole command, with nothing before or after it.
EOF

GIT_PUSH_RE='(^|[^[:alnum:]_.-])git([[:space:]]+-[^[:space:]]*([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+push([^[:alnum:]_-]|$)'
GH_RE='(^|[^[:alnum:]_.-])gh([[:space:];|&<>)}`]|$)'
HELP_RE='^[[:space:]]*git[[:blank:]]+push[[:blank:]]+--help[[:space:]]*$'
PROTECTED_RE='^(master|main|production)$'
DEST_RE='(^|[[:space:]:+]|refs/heads/)(master|main|production)([[:space:])]|$)'
ALL_RE='(^|[[:space:]])--(all|mirror)([[:space:])]|$)'
REF_ROUTE_RE='refs/heads/(master|main|production)([^[:alnum:]_./-]|$)'
WRITE_RE='(-[[:alpha:]]*X|--method)[[:space:]=]*(PATCH|POST|PUT|DELETE)([^[:alnum:]_]|$)|(^|[[:space:]])(-[[:alpha:]]*[fF]|--field|--raw-field|--input)([[:space:]=]|$)'
MUTATION_RE='createCommitOnBranch|updateRef|deleteRef'
NAME_RE='(^|[^[:alnum:]_/-])(master|main|production)([^[:alnum:]_/-]|$)'
PUSH_WORD_RE='[[:space:]]push[^[:alnum:]_.=-]'
DIR_RE='(^|[[:space:]])-C[[:space:]]+([^[:space:]]+)'
HEAD_RE='^[+]?HEAD(:HEAD)?$'
GRAPHQL_RE='(^|[^[:alnum:]_.-])gh[[:space:]]+api[[:space:]]+graphql([[:space:]]|$)'
TWO_GH_RE=$GH_RE'.*'$GH_RE

input=$(cat) || exit 0
jq empty <<<"$input" 2>/dev/null || exit 0
cmd=$(jq -r "$COMMAND_JQ" <<<"$input" 2>/dev/null) || guard_deny "$REASON"
text=$(jq -r "$DEQUOTED_JQ" <<<"$input" 2>/dev/null) || guard_deny "$REASON"
cwd=$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)

[[ $cmd =~ $HELP_RE ]] && guard_allow
graphql_only=0
[[ $text =~ $GRAPHQL_RE && ! $text =~ $TWO_GH_RE ]] && graphql_only=1
(( ! graphql_only )) && [[ $text =~ $GH_RE && $text =~ $REF_ROUTE_RE && $text =~ $WRITE_RE ]] && guard_deny "$REASON"
[[ $text =~ $MUTATION_RE ]] && [[ $text =~ $NAME_RE || $text =~ $REF_ROUTE_RE ]] && guard_deny "$REASON"

head_protected() { # <before>: the text of the segment before its push word
  local dir=$cwd branch named=0
  shopt -u nocasematch
  [[ $1 =~ $DIR_RE ]] && named=1
  shopt -s nocasematch
  if (( named )); then
    dir=${BASH_REMATCH[2]}
    [[ $dir == /* || -z $cwd ]] || dir=$cwd/$dir
  fi
  [[ -n $dir ]] || return 1
  branch=$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null) || return 1
  [[ $branch =~ $PROTECTED_RE ]]
}

IFS=$'\n;|&' read -r -d '' -a segs <<<"$text"
for seg in "${segs[@]+"${segs[@]}"}"; do
  [[ -n $seg && $seg =~ $GIT_PUSH_RE ]] || continue
  seg+=" "
  [[ $seg =~ $PUSH_WORD_RE ]] || continue
  hit=${BASH_REMATCH[0]}
  before=${seg%%"$hit"*}
  after=${seg#*"$hit"}
  [[ $after =~ $DEST_RE || $after =~ $ALL_RE ]] && guard_deny "$REASON"
  positionals=() tags=0 skip=0
  read -r -a words <<<"$after"
  for word in "${words[@]+"${words[@]}"}"; do
    if (( skip )); then skip=0; continue; fi
    case $word in
      -o | --push-option | --receive-pack | --exec | --repo) skip=1 ;;
      --tags) tags=1 ;;
      -*) ;;
      *) positionals+=("$word") ;;
    esac
  done
  bare=1
  for ((i = 1; i < ${#positionals[@]}; i++)); do
    [[ ${positionals[i]} =~ $HEAD_RE ]] || bare=0
  done
  (( bare )) || continue
  (( tags && ${#positionals[@]} <= 1 )) && continue
  head_protected "$before" && guard_deny "$REASON"
done
guard_allow
