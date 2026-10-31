#!/usr/bin/env bash
# Sourced by the guards. guard_deny answers in Claude Code's PreToolUse hookSpecificOutput shape;
# guard_allow is silence, which Claude Code takes as allow.
# Also holds the two jq filters the guards read a shell command with. COMMAND_JQ joins line
# continuations, as the shell does before it reads a word. DEQUOTED_JQ also drops every quote and
# backslash, so a word spelled in pieces (g"h", mer\ge, Que""ue.md) reads whole. Both use split and
# join, which are linear on a long command; a filter that fails means the command cannot be read,
# and the guards deny on it.
# shell_segments is the third reading: a tokenizer over the raw command that hands each shell segment
# (the words between unquoted `;`, `|`, `&`, newlines and parens) to a callback, quotes removed and
# quoted words kept whole. A redirection and its target are dropped, and so is a comment. The body of
# a `$(…)`, backtick or `<(…)` substitution is a segment of its own, and the word it sat in keeps
# SUBST in its place, so the enclosing command stays whole and a guard can refuse what it cannot
# read. The loop reads 1 KB chunks under LC_ALL=C and takes a run of plain bytes in one step, since
# `${text:i:1}` rescans the whole command and a byte-wise append recopies the word, and a long heredoc
# or quoted script would outrun the hook timeout; its state is local, so the callback may call it again.
COMMAND_JQ='.tool_input.command // empty | split("\\\n") | join("")'
DEQUOTED_JQ=$COMMAND_JQ' | split("\"") | join("") | split("\u0027") | join("") | split("\\") | join("")'
SUBST=$'\002'
guard_allow() { exit 0; }
guard_deny() { # <reason>
  jq -cn --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

shell_segments() { # <text> <callback>: runs <callback> <word>... once per segment that holds a word
  local LC_ALL=C
  local text=$1 cb=$2 n=${#1} i=0 c next top rest run stack=N word= have=0 skip=0 base=0
  local words=() fword=() fbase=() cs=()
  for ((i = 0; i < n; i += 1024)); do cs+=("${text:i:1024}"); done
  cs+=("")
  i=0
  while (( i < n )); do
    top=${stack:${#stack}-1}
    rest=${cs[i >> 10]:i & 1023}
    case $top in
      S) run=${rest%%\'*} ;;
      D) run=${rest%%[\"\\\$\`]*} ;;
      *) run=${rest%%[[:space:]\;\|\&\<\>\(\)\$\'\"\\\`\#]*} ;;
    esac
    if [[ -n $run ]]; then
      word+=$run have=1
      i=$((i + ${#run}))
      continue
    fi
    c=${rest:0:1}
    next=${cs[(i + 1) >> 10]:(i + 1) & 1023:1}
    case $top in
      S)
        if [[ $c == "'" ]]; then stack=${stack%?}; else word+=$c; fi ;;
      D)
        case $c in
          '"') stack=${stack%?} ;;
          '\')
            case $next in
              '$' | '"' | '\' | '`') word+=$next; i=$((i + 1)) ;;
              $'\n') i=$((i + 1)) ;;
              *) word+=$c ;;
            esac ;;
          '$') if [[ $next == '(' ]]; then _ss_open Q; i=$((i + 1)); else word+=$c; fi ;;
          '`') _ss_open B ;;
          *) word+=$c ;;
        esac ;;
      *)
        case $c in
          ' ' | $'\t') _ss_word ;;
          $'\n' | ';' | '|') _ss_segment ;;
          '&') if [[ $next == '>' ]]; then _ss_redirect; else _ss_segment; fi ;;
          '<' | '>') if [[ $next == '(' ]]; then _ss_open Q; i=$((i + 1)); else _ss_redirect; fi ;;
          '(') _ss_segment; stack+=P ;;
          ')')
            case $top in
              Q) _ss_close; stack=${stack%?} ;;
              P) _ss_segment; stack=${stack%?} ;;
              *) _ss_segment ;;
            esac ;;
          '`') if [[ $top == B ]]; then _ss_close; stack=${stack%?}; else _ss_open B; fi ;;
          '$') if [[ $next == '(' ]]; then _ss_open Q; i=$((i + 1)); else word+=$c; have=1; fi ;;
          '#')
            if (( have )); then
              word+=$c
            else
              while (( i + 1 < n )) && [[ ${cs[(i + 1) >> 10]:(i + 1) & 1023:1} != $'\n' ]]; do i=$((i + 1)); done
            fi ;;
          "'") stack+=S; have=1 ;;
          '"') stack+=D; have=1 ;;
          '\') [[ $next == $'\n' ]] || { word+=$next; have=1; }; i=$((i + 1)) ;;
          *) word+=$c; have=1 ;;
        esac ;;
    esac
    i=$((i + 1))
  done
  while (( ${#fword[@]} )); do _ss_close; done
  _ss_segment
}
_ss_word() { # shell_segments: the word read so far joins the segment, unless it is a redirection target
  (( have )) || return 0
  (( skip )) || words+=("$word")
  word= have=0 skip=0
}
_ss_segment() { # shell_segments: the segment's words go to the callback
  local k
  _ss_word
  skip=0
  (( ${#words[@]} > base )) || return 0
  "$cb" "${words[@]:base}"
  for ((k = ${#words[@]} - 1; k >= base; k--)); do unset 'words[k]'; done
}
_ss_redirect() { # shell_segments: an fd word glued before the operator is dropped, and so is the target
  if (( have )) && [[ $word =~ ^[0-9]+$ || $word =~ ^\{[A-Za-z_][A-Za-z0-9_]*\}$ ]]; then
    word= have=0
  else
    _ss_word
  fi
  local a b
  while true; do
    a=${cs[(i + 1) >> 10]:(i + 1) & 1023:1}
    b=${cs[(i + 2) >> 10]:(i + 2) & 1023:1}
    [[ $a == [\<\>\&\|] ]] && ! [[ $a == [\<\>] && $b == '(' ]] || break
    i=$((i + 1))
  done
  skip=1
}
_ss_open() { # <stack letter>: shell_segments: a substitution opens; the enclosing word and segment wait
  fword+=("$word")
  fbase+=("$base $skip")
  stack+=$1
  base=${#words[@]} word= have=0 skip=0
}
_ss_close() { # shell_segments: the substitution's body is a segment; the enclosing word resumes with SUBST
  local last=$((${#fword[@]} - 1)) saved
  _ss_segment
  saved=${fbase[last]}
  word=${fword[last]}$SUBST have=1
  base=${saved% *} skip=${saved#* }
  unset 'fword[last]' 'fbase[last]'
}
