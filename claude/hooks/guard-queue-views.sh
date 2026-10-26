#!/usr/bin/env bash
# Queue.md and Followups.md are written by claudeos only. Runs as Claude Code's PreToolUse (guard-common.sh
# holds the deny shape and the jq filters). Refuses every edit or write on the vault's generated
# views and on the vault-queues authority (Edit, MultiEdit, Write and NotebookEdit) and any Bash command that names either
# unless it only reads it. The one exception to the edit rule is an edit on the authority while
# `claudeos queue edit <project> begin` has an open session (<projects root>/.claudeos/edit/<project>,
# the root being the queues directory or the vault's projects/ folder when queues: is empty): Edit only.
# Relative paths are joined to the payload's cwd first. Without a cwd a relative path cannot be
# placed, so any one ending in a guarded name is refused.
# Every match ignores case: macOS opens queue.md as Queue.md. The exception does not: a path spelled
# in another case is refused under an open session too.
# A shell command is read with its line continuations joined and its quotes and backslashes dropped
# (guard-common.sh). It also names a guarded name through a relative word that the cwd, or a `cd` target
# in the command (each relative target joined to the one before, options skipped, quoted and bare
# pieces read as one target), places on a guarded path. A word counts when its last part is a guarded name
# or a glob or brace list that can expand to it (Queue.m[d], *.md, {Queue,Design}.md). Words also end
# at `=` (of=Queue.md). More than MAX_CD `cd` targets beside such a word, or more than MAX_PLACE
# placements, is refused unread: a guard that runs past its hook timeout does not block. A payload jq
# cannot read a command or path from is refused.
# A command that names a guarded name is still allowed when it only reads it: EVERY segment of
# the command (split at ; & | ( ) newline and backtick), named or not, starts with one of READERS as
# a bare word (no path, no env assignment, no sudo, env, xargs or time in front), and no word that
# could name a guarded name follows a > redirect anywhere (>, >>, >|, >!, &>, 2>, <>), and no redirect
# target starts with $, a backtick or ( or is followed by ( (`> $(ls Queue.md)`, `>Queue.md(|ls)`:
# the target is built at run time); a leading ! is read off a word (zsh `>!Queue.md`) and a word
# holding a (…) group is read as a glob (zsh `Queue.m(d|x)`); more than
# MAX_REDIRECT redirects or MAX_SEGMENT segments beside such a word is refused unread, like the cd
# cap (20000 segments took 8 s under bash 3.2, against the 10 s hook timeout). Checking every
# segment is what refuses a reader's output reaching a writer (`$(ls Queue.md)`, `| xargs rm`), a
# redefined reader (`cat(){ …; }`, `PATH=…`) and a zsh glob qualifier (`Queue.md(e:…:)`). So in a
# queue project directory `ls *.md`, `cat Queue.md | head` and `grep -n x Queue.md` are allowed and
# `sed -i`, `tee`, `cp`, `>>`, `echo`, `rg` (--pre, -z) and every unlisted program are refused. sed
# is not a reader: its script writes (`w file`, GNU `e cmd`) and a word test cannot tell that from a
# read. Not followed: variables, eval, $'…' quoting, scripts and interpreters, pushd, git -C,
# symlinks, a glob in a directory name, a directory handed to a recursive tool, `file -C`, a `{ …; }`
# group (its head word is `{`), a `>` inside a pattern (`grep '>' Queue.md` reads as a redirect). With
# no cwd and no `cd` a bare guarded name is allowed: a grep pattern cannot be told from a path.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-common.sh"

GUARDED=(Queue.md Followups.md)
NAME_RE='(Queue|Followups)\.md'
QUEUE_RE="(SecondBrain/projects|vault-queues|(^|[^[:alnum:]_/.-])projects)/[^/[:space:]]+/$NAME_RE"
read -r -d '' REASON <<'EOF'
Queue.md and Followups.md are written by claudeos only: the vault's projects/<P>/Queue.md and projects/<P>/Followups.md are GENERATED READ-ONLY VIEWS, overwritten on the next queue write, when queues: names a separate directory, and the authority itself when queues: is empty, and the vault-queues copies are the authority they regenerate from, where a hand edit leaves the repo dirty and every later queue write refused. Use the tools. Queue.md: claudeos queue state|lane|mark|add|stamp <project> <qN> ... for single-line changes, `claudeos queue edit <project> begin` then `claudeos queue edit <project> commit -m "..."` for free-form grooming, and claudeos queue dump|find <project> to read. Followups.md: claudeos followup add|list|tick <project> ...; no edit session covers it. Run `claudeos queue --help` or `claudeos followup --help` for syntax. A plain read of either file is allowed: ls, cat, head, tail, wc, grep, stat, diff, file, cut or nl as the bare command word of every part of the command, with no > redirect onto the file; this command is not one.
EOF
read -r -d '' OVERRUN <<'EOF'
The queue guard could not place every path in this command: it has too many cd targets, too many > redirects, too many command segments or too many words that could name a Queue.md or Followups.md, and a command the guard cannot finish reading is refused. Split it into shorter commands, or write the file with the Write tool instead of a heredoc.
EOF

clean_path() { # <path>: sets $placed to the path with its empty, `.` and `..` parts resolved
  local part out=() parts
  IFS=/ read -ra parts <<<"$1"
  for part in "${parts[@]}"; do
    case $part in
      ''|.) ;;
      ..) (( ${#out[@]} )) && out=("${out[@]:0:${#out[@]}-1}") ;;
      *) out+=("$part") ;;
    esac
  done
  local IFS=/
  if [[ $1 == /* ]]; then placed="/${out[*]-}"; else placed="${out[*]-}"; fi
}

absolute() { # <path> [base]: sets $placed; a relative path is joined to the base, the payload's cwd unless one is given, if any
  local p=$1 base=${2-$cwd}
  [[ $p == /* || -z $base ]] || p="$base/$p"
  clean_path "$p"
}

NAME_ONLY_RE="^$NAME_RE\$"

is_queue() { # <path from absolute>: a guarded path, or any guarded name left relative for want of a cwd
  [[ $1 =~ $QUEUE_RE ]] || [[ $1 != /* && ${1##*/} =~ $NAME_ONLY_RE ]]
}

session_open() { # <absolute .../<project>/Queue.md>: `claudeos queue edit <project> begin` is in flight
  local project_dir=${1%/Queue.md}
  [[ $1 == /*/Queue.md && -f ${project_dir%/*}/.claudeos/edit/${project_dir##*/} ]]
}

MAX_CD=16      # cd targets read beside a guarded name word
MAX_PLACE=512  # (guarded name word, base) pairs placed
MAX_WORD=4096  # a longer word or cd target is no path
MAX_BRACES=8   # brace lists read in one word
MAX_REDIRECT=64 # > redirects read beside a guarded name word
MAX_SEGMENT=4096 # command segments read beside a guarded name word
CD_RE="(^|[;&|(){}[:space:]])cd(([[:space:]]+-[-LPe@]*)*)[[:space:]]+((\"[^\"]*\"|'[^']*'|\\\\.|[^;&|()<>[:space:]\"'\\\\])+)(.*)\$"
BRACE_RE='^(.*)\{[^{}]*\}(.*)$'
QUOTES=$'["\'\\\\]'
# Words are split by IFS and tested by glob, and nothing here forks: bash 3.2 runs ${var//pattern/}
# and ${word##*/} in quadratic time, so both are kept to words of MAX_WORD at most, and a subshell
# per placement is what let a 2.6 KB command run for 12 s.
WORD_BREAK=$' \t\n;&|<>()`='
# zsh reads (a|b) and (x) inside a word as a glob group, so Queue.m(d|x) names Queue.md: words for
# that test break at blanks and redirects only, and each group is read as a `*` like a brace list.
PAREN_BREAK=$' \t\n;&<>`'
PAREN_RE='^(.*)\([^()]*\)(.*)$'
REDIRECT_OPEN_RE='>[>|&!]*[[:space:]]*[$`(]'
# The read exception: programs that only read the files named on their command line, and cd, which
# only moves where the next one reads.
READERS=' ls cat head tail wc grep stat diff file cut nl cd '
SEGMENT_BREAK=$'\n;&|()`'
HEAD_BREAK=$' \t'
REDIRECT_RE='>[>|&!]*[[:space:]]*([^[:space:];&|<>()`=]+)(.*)$'

guarded_name() { # <glob>: sets $guarded to the first of GUARDED the glob matches
  for guarded in "${GUARDED[@]}"; do [[ $guarded == $1 ]] && return 0; done
  return 1
}

names_queue() { # <dequoted word>: its last part could expand to a guarded name, or it holds a guarded path
  local word=$1 n=0 guarded
  [[ $word =~ $QUEUE_RE ]] && return 0
  if (( ${#word} > MAX_WORD )); then [[ $word == *{* ]]; return; fi
  [[ $word == -[[:alpha:]]* ]] && word=${word#-?}
  while (( n++ < MAX_BRACES )) && [[ $word =~ $BRACE_RE ]]; do word="${BASH_REMATCH[1]}*${BASH_REMATCH[2]}"; done
  [[ $word =~ $BRACE_RE ]] && return 0
  guarded_name "${word##*/}"
}

shell_names_queue() { # <command> <command dequoted>: a word that the cwd, or a `cd` target in the command, places on a guarded path
  local rest=$1 base=$cwd bases=("$cwd") target words word name named=() n
  # A word is recorded once, under the first guarded name it can expand to: placement tests its directory against QUEUE_RE, which takes every guarded name alike. The names are spelled out in the word loops because a function call per word is superlinear under bash 3.2.
  IFS=$WORD_BREAK read -r -d '' -a words <<<"$2"
  (( ${#words[@]} )) || return 1
  for word in "${words[@]}"; do
    if (( ${#word} > MAX_WORD )); then
      [[ $word == *{* ]] && named+=(Queue.md)
      continue
    fi
    word=${word#!}
    [[ $word == -[[:alpha:]]* ]] && word=${word#-?}
    n=0
    while (( n++ < MAX_BRACES )) && [[ $word =~ $BRACE_RE ]]; do word="${BASH_REMATCH[1]}*${BASH_REMATCH[2]}"; done
    if [[ $word =~ $BRACE_RE ]]; then
      name=${word%%\{*}
      named+=("${name%"${name##*/}"}Queue.md")
      continue
    fi
    name=${word##*/}
    if [[ Queue.md == $name ]]; then named+=("${word%"$name"}Queue.md")
    elif [[ Followups.md == $name ]]; then named+=("${word%"$name"}Followups.md"); fi
  done
  IFS=$PAREN_BREAK read -r -d '' -a words <<<"$2"
  for word in "${words[@]}"; do
    if (( ${#word} > MAX_WORD )); then
      [[ $word == *\(* ]] && named+=(Queue.md)
      continue
    fi
    [[ $word == *\(*\)* ]] || continue
    word=${word#!}
    n=0
    while (( n++ < MAX_BRACES )) && [[ $word =~ $PAREN_RE ]]; do word="${BASH_REMATCH[1]}*${BASH_REMATCH[2]}"; done
    name=${word##*/}
    if [[ Queue.md == $name ]]; then named+=("${word%"$name"}Queue.md")
    elif [[ Followups.md == $name ]]; then named+=("${word%"$name"}Followups.md"); fi
  done
  (( ${#named[@]} )) || return 1
  while [[ $rest =~ $CD_RE ]]; do
    rest=${BASH_REMATCH[6]}
    target=${BASH_REMATCH[4]}
    (( ${#target} > MAX_WORD )) && continue
    (( ${#bases[@]} > MAX_CD )) && guard_deny "$OVERRUN"
    absolute "${target//$QUOTES/}" "$base"
    base=$placed
    bases+=("$base")
  done
  (( ${#named[@]} * ${#bases[@]} > MAX_PLACE )) && guard_deny "$OVERRUN"
  for word in "${named[@]}"; do
    for base in "${bases[@]}"; do
      absolute "$word" "$base"
      [[ $placed =~ $QUEUE_RE ]] && return 0
    done
  done
  return 1
}

shell_reads_queue() { # <command dequoted>: every segment starts with a bare reader, and no guarded name word follows a > redirect
  local rest=$1 segments segment head args n=0
  [[ $1 =~ $REDIRECT_OPEN_RE ]] && return 1
  while [[ $rest =~ $REDIRECT_RE ]]; do
    (( n++ < MAX_REDIRECT )) || guard_deny "$OVERRUN"
    rest=${BASH_REMATCH[2]}
    names_queue "${BASH_REMATCH[1]}" && return 1
    [[ $rest == \(* ]] && return 1
  done
  IFS=$SEGMENT_BREAK read -r -d '' -a segments <<<"$1"
  (( ${#segments[@]} )) || return 1
  (( ${#segments[@]} > MAX_SEGMENT )) && guard_deny "$OVERRUN"
  for segment in "${segments[@]}"; do
    IFS=$HEAD_BREAK read -r head args <<<"$segment"
    [[ -z $head || -z $args && $head == [0-9] ]] && continue
    [[ $READERS == *" $head "* ]] || return 1
  done
  return 0
}

input=$(cat) || exit 0
tool=$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null) || exit 0
cwd=$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null) || exit 0

case "$tool" in
  Bash)
    cmd=$(jq -r "$COMMAND_JQ" <<<"$input" 2>/dev/null) || guard_deny "$REASON"
    text=$(jq -r "$DEQUOTED_JQ" <<<"$input" 2>/dev/null) || guard_deny "$REASON"
    [[ $cmd =~ $QUEUE_RE || $text =~ $QUEUE_RE ]] || shell_names_queue "$cmd" "$text" || guard_allow
    shell_reads_queue "$text" && guard_allow
    guard_deny "$REASON"
    ;;
  *)
    files=$(jq -r '.tool_input | [.file_path, .notebook_path][] | select(. != null) | tostring' <<<"$input" 2>/dev/null) || guard_deny "$REASON"
    while IFS= read -r file; do
      [[ -n $file ]] || continue
      absolute "$file"
      target=$placed
      is_queue "$target" || continue
      [[ $tool == Edit ]] && session_open "$target" && continue
      guard_deny "$REASON"
    done <<<"$files"
    guard_allow
    ;;
esac
