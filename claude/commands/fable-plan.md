---
description: Plan a task on Fable so a cheaper model can execute it in a separate session (pairs with /implement-plan)
argument-hint: "[task description]"
---

## Task

Produce a plan file that a less capable model (Opus/Sonnet) can execute **without judgment calls**. This session plans only. The pipeline: this command → `claude --model opus` → `/implement-plan`.

`$ARGUMENTS` is the task description. If empty, ask for it and stop.

## Steps

1. **Refine requirements.** Invoke `superpowers:brainstorming` with the task. Resolve every ambiguity here, with the user; an ambiguity left in the plan becomes a judgment call for a model chosen precisely because it should not make them.

2. **Write the plan.** Invoke `superpowers:writing-plans`. Save to `docs/plans/YYYY-MM-DD-<topic>.md`. NEVER commit the plan (global rule); add `docs/plans/` to `.git/info/exclude` if the repo doesn't ignore it.

3. **Make it executor-grade.** Beyond the writing-plans format, every phase must have:
   - Exact file paths and function signatures for each change.
   - Verbatim commands for tests/lint/typecheck with expected results.
   - Acceptance checks: observable behavior, not "should work".
   - A **stop-and-ask list** at the top of the plan. Minimum triggers: reality deviates from the plan (file moved, API changed), tests still failing after 2 fix attempts, ambiguous requirement discovered mid-phase, any security-sensitive decision not spelled out in the plan.

4. **Self-check.** Reread the plan as if you were Sonnet with no context: any step where two reasonable implementations exist? Fix it or move the decision to the stop-and-ask list.

5. **Hand off.** Print exactly this and stop:

   ```
   Plan ready: docs/plans/<file>.md
   Next: exit, then run
     claude --model opus     # sonnet if the plan is fully mechanical
     /implement-plan docs/plans/<file>.md
   ```

## Rules

- NO implementation in this session. No code edits, no branches, no commits. Writing the plan file is the only write this command performs.
- Model guidance for the handoff line: suggest `sonnet` when every phase is mechanical (renames, config plumbing, well-specified CRUD), `opus` when phases need minor local decisions.
