---
description: Plan a mid-complexity task on Opus with max thinking, for Sonnet to execute (cheap-path sibling of /fable-plan)
argument-hint: "<project> | <item: qN, #issue, or text> — or a plain task description [--council[=gemini|codex|agy]]"
---

ultrathink

## Task

Read `~/.claude/commands/fable-plan.md` and follow it exactly, with the deltas below. Do not restate or improvise its steps; that file is the single authority for the planning flow.

## Deltas

- **Model guard.** This command assumes an Opus session. If this session is running a different model, say which and ask whether to continue before doing anything else.
- **Handoff defaults to `sonnet`.** The planner should outrank the executor; suggest `opus` for execution only if a phase turned out less mechanical than expected, and say why.
- **Escalation valve.** This is the cheap path, for tasks whose solution shape is already known. If brainstorming keeps failing to resolve an ambiguity, or the item turns out to carry architectural, security, or data-integrity weight, stop and recommend replanning with `/fable-plan` instead of shipping a plan with judgment calls left in it.
