#!/usr/bin/env bash
# Sourced by the guards: answers in the dialect of the CLI that asked, told by the payload's
# hook_event_name. Gemini CLI's BeforeTool reads {"decision":"deny","reason":…} and parses stdout as
# JSON on every exit, so allow prints {}. Claude Code and Codex share the PreToolUse hookSpecificOutput
# shape and take silence as allow.
# Also holds the two jq filters the guards read a shell command with. COMMAND_JQ joins line
# continuations, as the shell does before it reads a word. DEQUOTED_JQ also drops every quote and
# backslash, so a word spelled in pieces (g"h", mer\ge, Que""ue.md) reads whole. Both use split and
# join, which are linear on a long command; a filter that fails means the command cannot be read,
# and the guards deny on it.
COMMAND_JQ='.tool_input.command // empty | split("\\\n") | join("")'
DEQUOTED_JQ=$COMMAND_JQ' | split("\"") | join("") | split("\u0027") | join("") | split("\\") | join("")'
guard_allow() { # <event>
  [[ $1 == BeforeTool ]] && echo '{}'
  exit 0
}
guard_deny() { # <event> <reason>
  if [[ $1 == BeforeTool ]]; then
    jq -cn --arg r "$2" '{decision:"deny",reason:$r}'
  else
    jq -cn --arg r "$2" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  fi
  exit 0
}
