#!/usr/bin/env bash
# Sourced by the guards. guard_deny answers in Claude Code's PreToolUse hookSpecificOutput shape;
# guard_allow is silence, which Claude Code takes as allow.
# Also holds the two jq filters the guards read a shell command with. COMMAND_JQ joins line
# continuations, as the shell does before it reads a word. DEQUOTED_JQ also drops every quote and
# backslash, so a word spelled in pieces (g"h", mer\ge, Que""ue.md) reads whole. Both use split and
# join, which are linear on a long command; a filter that fails means the command cannot be read,
# and the guards deny on it.
COMMAND_JQ='.tool_input.command // empty | split("\\\n") | join("")'
DEQUOTED_JQ=$COMMAND_JQ' | split("\"") | join("") | split("\u0027") | join("") | split("\\") | join("")'
guard_allow() { exit 0; }
guard_deny() { # <reason>
  jq -cn --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}
