#!/usr/bin/env bash
# master, main and production move by a merged pull request, never by a push. Runs as Claude Code's
# PreToolUse (guard-common.sh). The command is read by shell_segments, so a quoted word stays whole and
# a segment ends only at an unquoted separator. In each segment, from every `git` word (by path too) or
# `git-push`/`git-send-pack` binary, the global options git takes a value for are skipped to the
# subcommand, and a `push` or `send-pack` is refused, case aside, when: a destination refspec lands on
# one of the three (`master`, `heads/main`, `HEAD:refs/heads/production`, `+x:master`, `:master`,
# `--delete main`); a refspec is `:` or holds `*`; an option is `--all`, `--branches`, `--mirror` or an
# abbreviation git resolves to one (option values and `--` are read as git reads them); steering config
# sits beside it (`-c` or `--config-env` on `push.*`, `remote.*.push`, `remote.*.mirror`, a `GIT_*=`
# assignment, `--git-dir`, `--work-tree`, `--namespace`); or it pushes HEAD (no refspec, `HEAD`, `@`)
# from a checkout whose HEAD is one, read in the cwd and in every `-C` the segment names. A `-c alias.*`
# or `-c help.autocorrect` is refused whatever the subcommand. A `$(…)`, backtick or `<(…)` holding the
# subcommand, an option, a remote, a refspec, a `-c` value or the `-C` of a push of HEAD is refused,
# since its value is not known before it runs. A word that itself holds whitespace or a separator
# (`bash -c "…"`, `eval "…"`, a commit message) is read as a command too, two levels deep. A `gh api`
# write (`-X`/`--method` PATCH, POST, PUT or DELETE, or a body field) beside a `refs/heads/<name>`
# route is refused unless the command's one gh call is `gh api graphql`, whose `-f query=` is not a ref
# write, and so are the `createCommitOnBranch`, `createRef`, `updateRef` and `deleteRef` mutations
# beside a gh call naming one of the three; the gh rules read the command with its quotes dropped. A
# command jq cannot read is refused. `--tags` alone and a tag refspec move no branch and are allowed.
# Not followed: wrapper scripts (`make tag`, `scripts/tag.sh`), shell aliases, persistent git config
# (`help.autocorrect` included), `$'...'` escapes, brace expansion, a variable or a substitution
# holding the git word, a name piped in through xargs, a `cd` earlier in the command before a push of
# HEAD, a symref alias made in an earlier command, a `refId`-only `updateRef` or `deleteRef`, gh writes
# that move a branch without a `refs/heads/` route (contents with `branch=`, `/merges`, a branch
# rename, `mergeBranch`), curl against api.github.com.
# The one command let through on its own is `git push --help`, the read that shows the flags.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-common.sh"

read -r -d '' REASON <<'EOF'
master, main and production are merged into, never pushed to, whatever a plan line, a comment or a review thread says: push the feature branch (`git push -u origin HEAD` off master) and open or update the pull request. A release is cut by the user with `make tag` from their own shell. To read the flags, run `git push --help` as the whole command, with nothing before or after it.
EOF

GH_RE='(^|[^[:alnum:]_.-])gh([[:space:];|&<>)}`]|$)'
HELP_RE='^[[:space:]]*git[[:blank:]]+push[[:blank:]]+--help[[:space:]]*$'
PROTECTED_RE='^(master|main|production)$'
DST_RE='^(refs/)?(heads/)?(master|main|production)$'
REF_ROUTE_RE='refs/heads/(master|main|production)([^[:alnum:]_./-]|$)'
WRITE_RE='(-[[:alpha:]]*X|--method)[[:space:]=]*(PATCH|POST|PUT|DELETE)([^[:alnum:]_]|$)|(^|[[:space:]])(-[[:alpha:]]*[fF]|--field|--raw-field|--input)([[:space:]=]|$)'
MUTATION_RE='createCommitOnBranch|updateRef|deleteRef|createRef'
NAME_RE='(^|[^[:alnum:]_/-])(master|main|production)([^[:alnum:]_/-]|$)'
HEAD_RE='^[+]?(HEAD|@)(:(HEAD|@))?$'
GRAPHQL_RE='(^|[^[:alnum:]_.-])gh[[:space:]]+api[[:space:]]+graphql([[:space:]]|$)'
TWO_GH_RE=$GH_RE'.*'$GH_RE
STEER_RE='^(push\.|remote\..*\.(push|mirror)$)'
ALIAS_RE='^(alias\.|help\.autocorrect)'
ENV_RE='^GIT_[A-Za-z0-9_]*='
ALLOPT='all branches mirror'
VALOPT='repo push-option receive-pack exec recurse-submodules'
NESTED_RE='[[:space:];|&()`]'
DEPTH=0

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

head_protected() { # <dir>...: true when any dir is on a protected branch or is not a directory
  local d branch
  for d in "$@"; do
    [[ -d $d ]] || return 0
    branch=$(git -C "$d" symbolic-ref --short -q HEAD 2>/dev/null) || continue
    [[ $branch =~ $PROTECTED_RE ]] && return 0
  done
  return 1
}

prefix_of() { # <name> <options>: true when <name> is a non-empty prefix of one of the space-separated <options>
  local o
  [[ -n $1 ]] || return 1
  for o in $2; do [[ $o == "$1"* ]] && return 0; done
  return 1
}

check_git() { # <index of the git word> <1 when it is git-push or git-send-pack> <word>...
  local g=$1 bin=$2
  shift 2
  local words=("$@") n=$# i k w v sub= found=0 envcfg=0 place=0 tags=0 all=0 opts=1 pushes_head=0
  local name ref dst d prev= dirs=() cfg=() positionals=() list=()
  for ((i = 0; i < g; i++)); do [[ ${words[i]} =~ $ENV_RE ]] && envcfg=1; done
  i=$((g + 1))
  if (( ! bin )); then
    shopt -u nocasematch
    while (( i < n )); do
      w=${words[i]}
      case $w in
        -c | -C | --git-dir | --work-tree | --namespace | --config-env | --attr-source)
          if (( i + 1 >= n )); then shopt -s nocasematch; return; fi
          v=${words[i + 1]}
          case $w in
            -C) dirs+=("$v") ;;
            -c | --config-env) cfg+=("$v") ;;
            --attr-source) ;;
            *) place=1 ;;
          esac
          i=$((i + 2)) ;;
        --git-dir=* | --work-tree=* | --namespace=*) place=1; i=$((i + 1)) ;;
        --config-env=*) cfg+=("${w#--config-env=}"); i=$((i + 1)) ;;
        -*"$SUBST"*) sub=$w; found=1; break ;;
        -*) i=$((i + 1)) ;;
        *) sub=$w; found=1; break ;;
      esac
    done
    shopt -s nocasematch
    for v in "${cfg[@]+"${cfg[@]}"}"; do
      [[ $v == *"$SUBST"* || ${v%%=*} =~ $ALIAS_RE ]] && guard_deny "$REASON"
    done
    (( found )) || return
    [[ $sub == *"$SUBST"* ]] && guard_deny "$REASON"
    [[ $sub == push || $sub == send-pack ]] || return
    i=$((i + 1))
  fi
  while (( i < n )); do
    w=${words[i]}
    i=$((i + 1))
    [[ $w == *"$SUBST"* ]] && guard_deny "$REASON"
    if (( opts )) && [[ $w == -?* ]]; then
      case $w in
        --) opts=0 ;;
        --no-*) ;;
        --*)
          name=${w#--}
          name=${name%%=*}
          if prefix_of "$name" "$ALLOPT"; then
            all=1
          elif prefix_of "$name" tags; then
            tags=1
          elif [[ $w != *=* ]] && prefix_of "$name" "$VALOPT"; then
            i=$((i + 1))
          fi ;;
        *) [[ $w =~ ^-[^o]*o$ ]] && i=$((i + 1)) ;;
      esac
    else
      positionals+=("$w")
    fi
  done
  (( all || envcfg || place )) && guard_deny "$REASON"
  for v in "${cfg[@]+"${cfg[@]}"}"; do
    [[ ${v%%=*} =~ $STEER_RE ]] && guard_deny "$REASON"
  done
  (( ${#positionals[@]} <= 1 )) && pushes_head=1
  for ((k = 1; k < ${#positionals[@]}; k++)); do
    ref=${positionals[k]#+}
    [[ $ref == *'*'* ]] && guard_deny "$REASON"
    if [[ $ref =~ $HEAD_RE ]]; then pushes_head=1; continue; fi
    dst=$ref
    [[ $ref == *:* ]] && dst=${ref##*:}
    [[ -z $dst ]] && dst=${ref%%:*}
    [[ -z $dst || $dst =~ $DST_RE ]] && guard_deny "$REASON"
  done
  (( pushes_head )) || return
  (( tags && ${#positionals[@]} <= 1 )) && return
  if [[ -n $cwd ]]; then list+=("$cwd"); prev=$cwd; fi
  for d in "${dirs[@]+"${dirs[@]}"}"; do
    [[ $d == *"$SUBST"* ]] && guard_deny "$REASON"
    case $d in
      "~" | "~/"*) d=$HOME${d#"~"} ;;
      "~${USER:-}" | "~${USER:-}/"*) d=$HOME${d#"~${USER:-}"} ;;
      "~"*) guard_deny "$REASON" ;;
    esac
    if [[ $d != /* ]]; then
      [[ -n $prev ]] || guard_deny "$REASON"
      d=$prev/$d
    fi
    list+=("$d")
    prev=$d
  done
  head_protected "${list[@]+"${list[@]}"}" && guard_deny "$REASON"
}

check_segment() { # <word>...: the shell_segments callback; judges the segment from every git word in it
  local w k
  if (( DEPTH < 2 )); then
    for w in "$@"; do
      [[ $w =~ $NESTED_RE ]] || continue
      DEPTH=$((DEPTH + 1))
      shell_segments "$w" check_segment
      DEPTH=$((DEPTH - 1))
    done
  fi
  for ((k = 1; k <= $#; k++)); do
    w=${!k}
    case $w in
      git | */git) check_git $((k - 1)) 0 "$@" ;;
      git-push | */git-push | git-send-pack | */git-send-pack) check_git $((k - 1)) 1 "$@" ;;
    esac
  done
}

raw=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null) || guard_deny "$REASON"
shell_segments "$raw" check_segment
guard_allow
