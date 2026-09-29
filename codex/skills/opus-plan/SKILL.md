---
name: opus-plan
description: Plan a mid-complexity task for a Sonnet-grade executor (cheap-path sibling of $fable-plan). Use when the user runs $opus-plan with a project and queue item or a task description.
argument-hint: "<project> | <item: qN, #issue, or text> — or a plain task description [--notes <text…>]"
disable-model-invocation: true
---
## Task

Read `~/.codex/skills/fable-plan/SKILL.md` and follow it exactly on `$ARGUMENTS`, with the deltas below. Do not restate or improvise its steps; that file is the single authority for the planning flow.

This is the Codex copy of `~/.dotfiles/claude/commands/opus-plan.md`. The two change together.

## Deltas

- **Executor defaults to `sonnet`.** Write `model: sonnet` in the plan's frontmatter and print `sonnet` in the handoff; write `opus` in both only if a task turned out less mechanical than expected, and say why.
- **Escalation valve.** This is the cheap path, for tasks whose solution shape is already known. If step 5 keeps failing to resolve an ambiguity, or the item turns out to carry architectural, security, or data-integrity weight, stop and recommend replanning with `$fable-plan` instead of shipping a plan with judgment calls left in it.
- **Refused flags.** The refusal line of fable-plan's **Flags** section names `/opus-plan` in place of `/fable-plan`.
