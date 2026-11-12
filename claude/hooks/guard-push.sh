#!/usr/bin/env bash
# master, main and production move by a merged pull request, never by a push. Runs as Claude Code's
# PreToolUse (guard-common.sh). The command is read by shell_segments, so a quoted word stays whole and
# a segment ends only at an unquoted separator. In each segment, from every `git` word (by path, zsh's
# `=git`, or a file-name glob that matches it, `g?t`) or `git-push`/`git-send-pack`/`git-http-push`
# binary, the global options git takes a value for are
# skipped to the subcommand, and a `push`, `send-pack` or `http-push` is refused, case aside, when: a
# destination refspec lands on one of the three (`master`, `heads/main`, `HEAD:refs/heads/production`,
# `+x:master`, `:master`, `--delete main`); a refspec is `:` or holds `*`, `?`, `[` or `$` (a glob or
# an expansion whose value is not known before it runs); an option is `--all`, `--branches`,
# `--mirror` or an abbreviation git resolves to one (option values and `--` are read as git reads
# them); steering config sits beside it (`-c` or `--config-env` on `push.*`, `remote.*.push`,
# `remote.*.mirror`, `branch.*.merge`, a `GIT_*=` assignment before the git word or one an earlier segment left set,
# `--git-dir`, `--work-tree`, `--namespace`); or it pushes HEAD (no refspec, `HEAD`, `@`) from a
# checkout whose HEAD is one, read in the cwd and in every `-C` the segment names. A `git subtree push`
# or `git-subtree push` is refused when a word after `push` lands on one of the three. `env -C`,
# `--chdir`, `-S` and `--split-string` are refused, since they move git's checkout or hide the command
# in one word, and so is a `(` glued to a word (zsh's `g(i)t` group or `*(e:…:)` qualifier, which
# runs code), or in a word read as a command one holding `git … push`. A `-c` on `alias.*`, `include.*`,
# `includeIf.*` or `help.autocorrect` is refused whatever the subcommand, and so is a `GIT_CONFIG*`
# assignment in any segment, whatever follows (a wrapper the command runs with no git word of its own
# inherits it). A `$(…)`, backtick, `<(…)` or `$` expansion holding the subcommand, an option, a
# remote, a refspec, a `-c` value or the `-C` of a push of HEAD is refused, since its value is not
# known before it runs, and so is one in a word before the git word (which `env` reads as
# assignments) other than a leading `NAME=` assignment, whatever the subcommand. In a quoted word read
# as a command that last rule holds only when the git word goes on to `push`, `send-pack`,
# `http-push`, `subtree` or `config`, or is a `git-push`, `git-send-pack` or `git-http-push` binary,
# so prose holding a `$` before the word git (a launch goal, a commit message, queue text) is not
# refused. An unquoted one is refused anywhere before the subcommand whatever the subcommand, and
# anywhere in a push, option values included, since it splits into words when it runs. A word that
# itself holds whitespace or a separator (`bash -c "…"`, `eval "…"`, a commit message, a heredoc body)
# is read as a command too, two levels deep, and one still holding a separator and `git … push` at
# that depth is refused, and so is a word holding `$IFS` or `${IFS…}` and `git … push`, which a
# `bash -c` body splits. A `send-pack` or `http-push` with `--stdin` or no ref is refused, since it
# reads its refs elsewhere or pushes the matching ones. What would skip the dotfiles pre-push hook
# (git/hooks/pre-push, the control that reads the destination refs) is refused whatever follows:
# `--no-verify` or an abbreviation of it on a push, `core.hooksPath` by `-c` or `--config-env`, a
# `git config` or `git-config` write of it or of an `alias.*`, `include.*`, `includeIf.*` or
# `help.autocorrect` key, or a section removal or rename touching `core`, `alias`, `include`,
# `includeIf` or `help` (a `--get` read before the key passes), a `CLAUDECODE=` assignment, `CLAUDECODE` beside
# `unset`, `export`, `declare`, `typeset`, `local` or `readonly`, `env -u`/`--unset` naming it,
# `env -i`, `--ignore-environment` or a bare `-`. A command longer than MAX_BYTES, more than
# MAX_REREADS words read as a command, more than MAX_GIT git words in all, MAX_WORDS words in a segment
# holding a git word, MAX_DIR `-C` in a git
# command or MAX_READS checkouts read is refused unread: each costs the guard time, and a guard that
# runs past its hook timeout does not block. A `gh api` write (`-X`/`--method` PATCH, POST, PUT or DELETE, or a body
# field) beside a `refs/heads/<name>`
# route is refused unless the command's one gh call is `gh api graphql`, whose `-f query=` is not a ref
# write, and so are the `createCommitOnBranch`, `createRef`, `updateRef` and `deleteRef` mutations
# beside a gh call naming one of the three; the gh rules read the command with its quotes dropped. A
# command jq cannot read is refused. `--tags` alone and a tag refspec move no branch and are allowed.
# The guard is a tripwire against an ordinary push, not a boundary: a command can build its git call
# at run time (an interpreter, a pipe into `sh`, `hash`, `find -exec`, a renamed or case-folded
# binary, a variable split by `${=x}` or a `bash -c` body), and those spellings are not read here;
# the pre-push hook reads the refs they end in.
# Not followed: wrapper scripts (`make tag`, `scripts/tag.sh`), shell aliases, persistent git config
# (`help.autocorrect` included, and a planted one under a `HOME=` or `XDG_CONFIG_HOME=` prefix), `$'...'` escapes in a word read as a command (`bash -c $'…'`), brace
# expansion, a variable or substitution holding the git word, a name piped in through
# xargs, a `GIT_*` variable set by `read`, `printf -v` or a sourced file, a `cd` earlier in the
# command before a push of HEAD, a symref alias made in an earlier command, a `refId`-only `updateRef` or `deleteRef`, gh writes
# that move a branch without a `refs/heads/` route (contents with `branch=`, `/merges`, a branch
# rename, `mergeBranch`), curl against api.github.com.
# The one command let through on its own is `git push --help`, the read that shows the flags.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-common.sh"

read -r -d '' REASON <<'EOF'
master, main and production are merged into, never pushed to, whatever a plan line, a comment or a review thread says: push the feature branch (`git push -u origin HEAD` off master) and open or update the pull request. A release is cut by the user with `make tag` from their own shell. To read the flags, run `git push --help` as the whole command, with nothing before or after it.
EOF
read -r -d '' OVERRUN <<'EOF'
The push guard could not finish reading this command: it is longer than 32 KB, or holds too many words beside a git word, git words, -C options, quoted strings read as commands, or pushes of HEAD whose checkout must be read, and a command the guard cannot finish reading is refused. Split it into shorter commands, or write a long text to a file first.
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
STEER_RE='^(push\.|remote\..*\.(push|mirror)$|branch\..*\.merge$)'
ALIAS_RE='^(alias\.|include\.|includeIf\.|help\.autocorrect|core\.hookspath)'
SECTION_RE='^(core|alias|include|includeIf|help)([.]|$)'
REF_GLOB_RE='[*?[$]'
ANY_EXP="[$SUBST$QSUBST\$]"
ALLOPT='all branches mirror'
VALOPT='repo push-option receive-pack exec recurse-submodules'
CONFIG_VALOPT='file blob type default comment value'
NESTED='[[:space:];|&()`]'
DEEP_RE='git.*(push|send-pack)'
MAX_GIT=32 # git words judged in the whole command, each walking its segment
MAX_DIR=16 # -C options read in one git command
MAX_READS=64 # checkouts whose HEAD is read in the whole command, one git process each
MAX_BYTES=32768 # command length read at all
MAX_REREADS=128 # quoted words re-read as a command, one shell_segments call each
MAX_WORDS=1024 # words in a segment that holds a git word, each indexed per git word
READS=0
GITS=0
REREADS=0
DEPTH=0
ENV_SET=0 # 1 once a segment leaves a GIT_* variable set
LEVEL=0

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
    (( ++READS <= MAX_READS )) || guard_deny "$OVERRUN"
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

refspec_protected() { # <refspec, + dropped>: true when it can land on a protected branch
  local dst=$1
  [[ $1 =~ $REF_GLOB_RE ]] && return 0
  [[ $1 == *:* ]] && dst=${1##*:}
  [[ -z $dst ]] && dst=${1%%:*}
  [[ -z $dst || $dst =~ $DST_RE ]]
}

check_subtree() { # <word>... after `git subtree`: a push is refused when a later word can land on a protected branch
  local w pushing=0
  for w in "$@"; do
    [[ $w == *"$SUBST"* ]] && guard_deny "$REASON"
    if (( pushing )); then
      [[ $w == *$ANY_EXP* ]] && guard_deny "$REASON"
      [[ $w != -* ]] && refspec_protected "${w#+}" && guard_deny "$REASON"
    elif [[ $w == push ]]; then
      pushing=1
    fi
  done
}

check_config() { # <word>... after `git config`: a write naming core.hooksPath or an ALIAS_RE key, or a section op on one, is refused; a --get read before the key is not
  local w get=0 section=0 value=0
  for w in "$@"; do
    if (( value )); then
      value=0
    else
      case $w in
        --get*) get=1 ;;
        --remove-section | --rename-section | remove-section | rename-section) section=1 ;;
        -f) value=1 ;;
        --?*) [[ $w != *=* ]] && prefix_of "${w#--}" "$CONFIG_VALOPT" && value=1 ;;
      esac
    fi
    (( section )) && [[ $w =~ $SECTION_RE ]] && guard_deny "$REASON"
    [[ $w =~ $ALIAS_RE ]] && { (( get )) || guard_deny "$REASON"; }
  done
  return 0
}

check_git() { # <index of the git word> <push, send-pack or http-push for a git-<that> binary, empty for git> <word>...
  local g=$1 sub=$2
  shift 2
  local words=("$@") n=$# i k w v found=0 stdin=0 envcfg place=0 tags=0 all=0 opts=1 pushes_head=0 skipnext=0
  local name ref d prev= dirs=() cfg=() positionals=() list=() lead=1
  env_level "${words[@]:0:g}"
  for ((i = 0; i < g; i++)); do
    w=${words[i]}
    [[ $lead == 1 && $w == [A-Za-z_]*=* && ${w%%=*} != *[!A-Za-z0-9_]* ]] && continue
    lead=0
    [[ $w == *$ANY_EXP* ]] && LEVEL=2
  done
  envcfg=$(( LEVEL > ENV_SET ? LEVEL : ENV_SET ))
  (( envcfg == 2 )) && (( DEPTH == 0 )) && guard_deny "$REASON"
  (( envcfg == 2 )) && [[ -n $sub ]] && guard_deny "$REASON"
  i=$((g + 1))
  if [[ -z $sub ]]; then
    shopt -u nocasematch
    while (( i < n )); do
      w=${words[i]}
      [[ $w == *"$SUBST"* ]] && guard_deny "$REASON"
      case $w in
        -c | -C | --git-dir | --work-tree | --namespace | --config-env | --attr-source)
          if (( i + 1 >= n )); then shopt -s nocasematch; return; fi
          v=${words[i + 1]}
          [[ $v == *"$SUBST"* ]] && guard_deny "$REASON"
          case $w in
            -C) (( ${#dirs[@]} < MAX_DIR )) || guard_deny "$OVERRUN"; dirs+=("$v") ;;
            -c | --config-env) cfg+=("$v") ;;
            --attr-source) ;;
            *) place=1 ;;
          esac
          i=$((i + 2)) ;;
        --git-dir=* | --work-tree=* | --namespace=*) place=1; i=$((i + 1)) ;;
        --config-env=*) cfg+=("${w#--config-env=}"); i=$((i + 1)) ;;
        -*$ANY_EXP*) sub=$w; found=1; break ;;
        -*) i=$((i + 1)) ;;
        *) sub=$w; found=1; break ;;
      esac
    done
    shopt -s nocasematch
    for v in "${cfg[@]+"${cfg[@]}"}"; do
      [[ $v == *$ANY_EXP* || ${v%%=*} =~ $ALIAS_RE ]] && guard_deny "$REASON"
    done
    (( found )) || return
    [[ $sub == *$ANY_EXP* ]] && guard_deny "$REASON"
    (( envcfg == 2 )) && [[ $sub == subtree || $sub == config || $sub == push || $sub == send-pack || $sub == http-push ]] && guard_deny "$REASON"
    if [[ $sub == subtree ]]; then
      check_subtree "${words[@]:i+1}"
      return
    fi
    if [[ $sub == config ]]; then check_config "${words[@]:i+1}"; return; fi
    [[ $sub == push || $sub == send-pack || $sub == http-push ]] || return
    i=$((i + 1))
  fi
  while (( i < n )); do
    w=${words[i]}
    i=$((i + 1))
    if (( skipnext )); then
      skipnext=0
      [[ $w == *"$SUBST"* ]] && guard_deny "$REASON"
      continue
    fi
    [[ $w == *$ANY_EXP* ]] && guard_deny "$REASON"
    if (( opts )) && [[ $w == -?* ]]; then
      case $w in
        --) opts=0 ;;
        --no-*) name=${w#--no-}; name=${name%%=*}; prefix_of "$name" verify && guard_deny "$REASON" ;;
        --*)
          name=${w#--}
          name=${name%%=*}
          if prefix_of "$name" "$ALLOPT"; then
            all=1
          elif prefix_of "$name" tags; then
            tags=1
          elif prefix_of "$name" stdin; then
            stdin=1
          elif [[ $w != *=* ]] && prefix_of "$name" "$VALOPT"; then
            skipnext=1
          fi ;;
        *) [[ $w =~ ^-[^o]*o$ ]] && skipnext=1 ;;
      esac
    else
      positionals+=("$w")
    fi
  done
  (( all || envcfg || place )) && guard_deny "$REASON"
  [[ $sub != push ]] && (( stdin || ${#positionals[@]} <= 1 )) && guard_deny "$REASON"
  for v in "${cfg[@]+"${cfg[@]}"}"; do
    [[ ${v%%=*} =~ $STEER_RE ]] && guard_deny "$REASON"
  done
  (( ${#positionals[@]} <= 1 )) && pushes_head=1
  for ((k = 1; k < ${#positionals[@]}; k++)); do
    ref=${positionals[k]#+}
    if [[ $ref =~ $HEAD_RE ]]; then pushes_head=1; continue; fi
    refspec_protected "$ref" && guard_deny "$REASON"
  done
  (( pushes_head )) || return
  (( tags && ${#positionals[@]} <= 1 )) && return
  if [[ -n $cwd ]]; then list+=("$cwd"); prev=$cwd; fi
  for d in "${dirs[@]+"${dirs[@]}"}"; do
    [[ $d == *$ANY_EXP* ]] && guard_deny "$REASON"
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

env_level() { # <word>...: LEVEL is 1 when a word assigns a GIT_* variable, else 0
  local w
  LEVEL=0
  for w in "$@"; do
    case $w in
      GIT_*=*) LEVEL=1 ;;
    esac
  done
}

persistent_env() { # <word>...: a GIT_* assignment left set for the rest of the command (bare, or by export and its kin) raises ENV_SET
  local w
  for w in "$@"; do
    case $w in
      [A-Za-z_]*=*) ;;
      export | declare | typeset | readonly | local) break ;;
      *) return 0 ;;
    esac
  done
  env_level "$@"
  (( LEVEL > ENV_SET )) && ENV_SET=$LEVEL
  return 0
}

arming_kept() { # <word>...: a segment that assigns or unsets CLAUDECODE, or assigns a GIT_CONFIG* variable, is refused, whatever follows
  local w kill=0 name=0
  for w in "$@"; do
    case $w in
      GIT_CONFIG*=*) guard_deny "$REASON" ;;
      CLAUDECODE=*) guard_deny "$REASON" ;;
      unset | export | declare | typeset | local | readonly) kill=1 ;;
      CLAUDECODE) name=1 ;;
    esac
  done
  (( kill && name )) && guard_deny "$REASON"
  return 0
}

glob_name() { # <word holding GLOB>: NAME is the first of git, its push binaries and env that the word's file-name glob matches
  local p=${1//$GLOB/} n
  p=${p##*/}
  for n in git git-push git-send-pack git-http-push git-subtree git-config env; do
    case $n in $p) NAME=$n; return 0 ;; esac
  done
  return 1
}

check_segment() { # <word>...: the shell_segments callback; judges the segment from every git word in it
  local w c name glued k=0 bin envopt=0
  arming_kept "$@"
  for w in "$@"; do
    case $w in *'$IFS'* | *'${IFS'*) [[ $w =~ $DEEP_RE ]] && guard_deny "$REASON" ;; esac
    case $w in *$NESTED*) ;; *) continue ;; esac
    if (( DEPTH >= 2 )); then
      [[ $w =~ $DEEP_RE ]] && guard_deny "$REASON"
      continue
    fi
    (( ++REREADS <= MAX_REREADS )) || guard_deny "$OVERRUN"
    glued=$GLUED_PAREN
    DEPTH=$((DEPTH + 1))
    shell_segments "$w" check_segment
    DEPTH=$((DEPTH - 1))
    if (( GLUED_PAREN && ! glued )); then
      [[ $w =~ $DEEP_RE ]] && guard_deny "$REASON"
      GLUED_PAREN=0
    fi
  done
  for w in "$@"; do
    k=$((k + 1))
    if (( envopt == 2 )); then
      [[ $w == CLAUDECODE ]] && guard_deny "$REASON"
      envopt=1
      continue
    fi
    if (( envopt )); then
      case $w in
        --?*)
          name=${w#--}
          name=${name%%=*}
          prefix_of "$name" "chdir split-string" && guard_deny "$REASON"
          prefix_of "$name" ignore-environment && guard_deny "$REASON"
          [[ $w == *=* ]] && prefix_of "$name" unset && [[ ${w#*=} == CLAUDECODE ]] && guard_deny "$REASON"
          [[ $w != *=* ]] && prefix_of "$name" unset && envopt=2
          continue ;;
        -) guard_deny "$REASON" ;;
        -*[CSi]*) guard_deny "$REASON" ;;
        -*u*CLAUDECODE) guard_deny "$REASON" ;;
        -*[uPLU]) envopt=2; continue ;;
        -* | [A-Za-z_]*=*) continue ;;
        *) envopt=0 ;;
      esac
    fi
    c=${w#=}
    case $c in *"$GLOB"*) glob_name "$c" || continue; c=$NAME ;; esac
    case $c in
      env | */env) envopt=1; continue ;;
      git | */git) bin= ;;
      git-push | */git-push | git-send-pack | */git-send-pack | git-http-push | */git-http-push | git-subtree | */git-subtree | git-config | */git-config) bin=${c##*/}; bin=${bin#git-} ;;
      *) continue ;;
    esac
    (( ++GITS <= MAX_GIT && $# <= MAX_WORDS )) || guard_deny "$OVERRUN"
    case $bin in
      subtree) check_subtree "${@:k+1}" ;;
      config) check_config "${@:k+1}" ;;
      *) check_git $((k - 1)) "$bin" "$@" ;;
    esac
  done
  persistent_env "$@"
}

within_bytes() { local LC_ALL=C; (( ${#raw} <= MAX_BYTES )); }

raw=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null) || guard_deny "$REASON"
within_bytes || guard_deny "$OVERRUN"
shell_segments "$raw" check_segment
(( GLUED_PAREN )) && guard_deny "$REASON"
guard_allow
