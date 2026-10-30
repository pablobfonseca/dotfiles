#!/usr/bin/env bash
# master, main and production move by a merged pull request, never by a push. Runs as Claude Code's
# PreToolUse (guard-common.sh). Refuses, case aside: a `git push`, `git send-pack` or `git-push`
# whose refspec lands on one of the three (`master`, `heads/main`, `HEAD:refs/heads/production`,
# `+x:master`, `:master`, `--delete main`), a matching (`:`) or pattern (`*`) refspec, `--all` and
# `--mirror`, a segment with two push words, and a push of HEAD (no refspec, `HEAD`, `@`) from a
# checkout whose HEAD is one, read in the cwd and in every `-C <dir>` the segment names, or one that
# sets `push.default`, `remote.*.push` or `remote.*.mirror`, or names `--git-dir`, `--work-tree`,
# `GIT_DIR=` or `GIT_WORK_TREE=`; a `gh api` write (`-X`/`--method` PATCH, POST, PUT or DELETE, or a
# body field) beside a `refs/heads/<name>` route, unless the command's one gh call is
# `gh api graphql`, whose `-f query=` is not a ref write; and, beside a gh call, the
# `createCommitOnBranch`, `updateRef` and `deleteRef` mutations when the command names one of the
# three. The command is read with its line continuations joined and its quotes and backslashes
# dropped, and split into shell segments on `;`, `|`, `&` and newlines, so a protected name counts
# only inside the segment that pushes; a global option may be followed by several words, since a
# quoted value with a space reads as more than one. `--tags` alone and a tag refspec move no branch
# and are allowed. A command jq cannot read is refused. Not followed: aliases, wrapper scripts
# (`make tag`, `scripts/tag.sh`), a variable or a substitution holding a word, eval, a script file,
# `$'...'` escapes, brace expansion, persistent config (`git config remote.origin.push`), a `cd`
# earlier in the command or a `-C` path holding a space before a push of HEAD, a `refId`-only
# `updateRef` or `deleteRef`, gh writes that move a branch without a `refs/heads/` route (contents
# with `branch=`, `/merges`, a branch rename, `mergeBranch`), curl against api.github.com.
# The one command let through on its own is `git push --help`, the read that shows the flags.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-common.sh"

read -r -d '' REASON <<'EOF'
master, main and production are merged into, never pushed to, whatever a plan line, a comment or a review thread says: push the feature branch (`git push -u origin HEAD` off master) and open or update the pull request. A release is cut by the user with `make tag` from their own shell. To read the flags, run `git push --help` as the whole command, with nothing before or after it.
EOF

GIT_PUSH_RE='(^|[^[:alnum:]_.-])git([[:space:]]+-[^[:space:]]*([[:space:]]+[^-[:space:]][^[:space:]]*)*)*[[:space:]]+(push|send-pack)([^[:alnum:]_.=-]|$)|(^|[^[:alnum:]_.-])git-push([[:space:]]|$)'
GH_RE='(^|[^[:alnum:]_.-])gh([[:space:];|&<>)}`]|$)'
HELP_RE='^[[:space:]]*git[[:blank:]]+push[[:blank:]]+--help[[:space:]]*$'
PROTECTED_RE='^(master|main|production)$'
DST_RE='^(refs/)?(heads/)?(master|main|production)[)]*$'
ALL_RE='(^|[[:space:]])--(all|mirror)([[:space:])]|$)'
REF_ROUTE_RE='refs/heads/(master|main|production)([^[:alnum:]_./-]|$)'
WRITE_RE='(-[[:alpha:]]*X|--method)[[:space:]=]*(PATCH|POST|PUT|DELETE)([^[:alnum:]_]|$)|(^|[[:space:]])(-[[:alpha:]]*[fF]|--field|--raw-field|--input)([[:space:]=]|$)'
MUTATION_RE='createCommitOnBranch|updateRef|deleteRef'
NAME_RE='(^|[^[:alnum:]_/-])(master|main|production)([^[:alnum:]_/-]|$)'
PUSH_WORD_RE='([[:space:]]|[^[:alnum:]_.-]git-)(push|send-pack)[^[:alnum:]_.=-]'
DIR_RE='(^|[[:space:]])-C[[:space:]]+([^[:space:]]+)'
HEAD_RE='^[+]?(HEAD|@)(:(HEAD|@))?[)]*$'
CONFIG_RE='push\.default|remote\.[^[:space:]]*\.(push|mirror)|--git-dir|--work-tree|GIT_DIR=|GIT_WORK_TREE='
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
[[ $text =~ $GH_RE && $text =~ $MUTATION_RE ]] && [[ $text =~ $NAME_RE || $text =~ $REF_ROUTE_RE ]] && guard_deny "$REASON"

head_protected() { # <segment>: true when the cwd or any checkout a `-C` names is on a protected branch
  local rest=$1 dir=$cwd d branch dirs=()
  [[ -n $cwd ]] && dirs+=("$cwd")
  shopt -u nocasematch
  while [[ $rest =~ $DIR_RE ]]; do
    d=${BASH_REMATCH[2]}
    rest=${rest#*"${BASH_REMATCH[0]}"}
    [[ $d == "~" || $d == "~/"* ]] && d=$HOME${d#"~"}
    if [[ $d == /* ]]; then
      dir=$d
    elif [[ -n $dir ]]; then
      dir=$dir/$d
      [[ -n $cwd ]] && dirs+=("$cwd/$d")
    else
      continue
    fi
    dirs+=("$dir")
  done
  shopt -s nocasematch
  for d in "${dirs[@]+"${dirs[@]}"}"; do
    branch=$(git -C "$d" symbolic-ref --short -q HEAD 2>/dev/null) || continue
    [[ $branch =~ $PROTECTED_RE ]] && return 0
  done
  return 1
}

IFS=$'\n;|&' read -r -d '' -a segs <<<"$text"
for seg in "${segs[@]+"${segs[@]}"}"; do
  [[ -n $seg && $seg =~ $GIT_PUSH_RE ]] || continue
  s=" $seg "
  [[ $s =~ $PUSH_WORD_RE ]] || continue
  hit=${BASH_REMATCH[0]}
  after=${s#*"$hit"}
  [[ " $after" =~ $PUSH_WORD_RE ]] && guard_deny "$REASON"
  [[ $after =~ $ALL_RE ]] && guard_deny "$REASON"
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
  pushes_head=0
  (( ${#positionals[@]} <= 1 )) && pushes_head=1
  for ((i = 1; i < ${#positionals[@]}; i++)); do
    ref=${positionals[i]#+}
    [[ $ref == *'*'* ]] && guard_deny "$REASON"
    if [[ $ref =~ $HEAD_RE ]]; then pushes_head=1; continue; fi
    dst=$ref
    [[ $ref == *:* ]] && dst=${ref##*:}
    [[ -z $dst ]] && dst=${ref%%:*}
    [[ -z $dst || $dst =~ $DST_RE ]] && guard_deny "$REASON"
  done
  (( pushes_head )) || continue
  (( tags && ${#positionals[@]} <= 1 )) && continue
  [[ $seg =~ $CONFIG_RE ]] && guard_deny "$REASON"
  head_protected "$seg" && guard_deny "$REASON"
done
guard_allow
