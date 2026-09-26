#!/usr/bin/env bash
# Sourced by the guards: answers in the dialect of the CLI that asked, told by the payload's
# hook_event_name. Gemini CLI's BeforeTool reads {"decision":"deny","reason":…} and parses stdout as
# JSON on every exit, so allow prints {}. Claude Code and Codex share the PreToolUse hookSpecificOutput
# shape and take silence as allow.
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
