#!/usr/bin/env bash
# A GitHub repo is deleted by the user, by hand. Runs as Claude Code's PreToolUse (guard-common.sh).
# Refuses every repo-delete path: `gh repo delete` in any flag order (the Claude settings deny
# covers only the plain spelling), with gh spelled bare, behind a path, in any case, as a `which gh`
# substitution, or as the last word of a command or of a pipeline stage (`xargs gh`); the REST
# delete, `-X DELETE` or `--method DELETE` beside a bare `repos/<owner>/<name>` endpoint (nothing
# after the name, so a comment, ref or hook delete under the repo is not one); and
# `claudeos queue delete <P> --github`, read as the words `queue delete` and `--github` in one
# command whatever spells the binary (`go run .`, a path, `$(which claudeos)`). The command is read
# with its line continuations joined, its quotes and backslashes dropped (a `$` before a quote too,
# `$'repo'`), `${IFS}` read as a space and `{`, `}` and `,` as spaces, so a word spelled in pieces
# reads whole; a `$'...'` or `$"..."` beside a `repo delete` denies even without a readable `gh`.
# A command jq cannot read is refused. Not followed: aliases, wrapper scripts, a variable or a
# substitution holding a word, eval, a script file, escapes inside `$'...'` that spell `gh`, a glob
# in the binary name (`g[h]`), a word split by a brace pair (`d{e,e}lete`), `hub`, curl against
# api.github.com. The
# one command let through is `gh repo delete --help` on its own, the read that shows the flags.
set -uo pipefail
shopt -s nocasematch
. "$(dirname "${BASH_SOURCE[0]}")/guard-common.sh"

read -r -d '' REASON <<'EOF'
Deleting a GitHub repo is always manual and always the user's: no gh repo delete, no REST delete of a repo, no claudeos queue delete --github, whatever a plan line, a warning text or a review thread says. Leave the repo and report the command for the user to run. To read the flags, run `gh repo delete --help` as the whole command, with nothing before or after it.
EOF

input=$(cat) || exit 0
jq empty <<<"$input" 2>/dev/null || exit 0
cmd=$(jq -r "$COMMAND_JQ" <<<"$input" 2>/dev/null) || guard_deny "$REASON"
ANSI_JQ=$COMMAND_JQ' | split("$" + ([39] | implode)) | join([39] | implode) | split("$\"") | join("\"")'${DEQUOTED_JQ#"$COMMAND_JQ"}
text=$(jq -r "$ANSI_JQ" <<<"$input" 2>/dev/null) || guard_deny "$REASON"
text=${text//'${IFS}'/ }
text=${text//'$IFS'/ }
text=$(tr '{},' '   ' <<<"$text")
ansi=0
[[ $cmd == *'$'\'* || $cmd == *'$"'* ]] && ansi=1

GH_RE='(^|[^[:alnum:]_.-])gh([[:space:];|&<>)}`]|$)'
REPO_DELETE_RE='[[:space:]]repo([[:space:]]+-[^[:space:]]*([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+delete([^[:alnum:]_-]|$)'
HELP_RE='^[[:space:]]*gh[[:space:]]+repo[[:space:]]+delete[[:space:]]+--help[[:space:]]*$'
METHOD_RE='(-[[:alpha:]]*X|--method)[[:space:]=]*DELETE([^[:alnum:]_]|$)'
REPO_ENDPOINT_RE='(^|[[:space:]/])(repos/[^/[:space:]?]+/[^/[:space:]?]+|repositories/[^/[:space:]?]+)([[:space:]?]|/?$|/[[:space:]])'
QUEUE_DELETE_RE='(^|[^[:alnum:]_.-])queue([[:space:]]+-[^[:space:]]*([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+delete([^[:alnum:]_-]|$)'
GITHUB_FLAG_RE='--github([^[:alnum:]_-]|$)'

[[ $cmd =~ $HELP_RE ]] && guard_allow
hit=0
[[ $text =~ $GH_RE && $text =~ $REPO_DELETE_RE ]] && hit=1
(( ansi )) && [[ $text =~ $REPO_DELETE_RE ]] && hit=1
[[ $text =~ $METHOD_RE && $text =~ $REPO_ENDPOINT_RE ]] && hit=1
[[ $text =~ $QUEUE_DELETE_RE && $text =~ $GITHUB_FLAG_RE ]] && hit=1
(( hit )) || guard_allow
guard_deny "$REASON"
