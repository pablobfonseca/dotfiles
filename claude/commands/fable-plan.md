---
description: Plan a task on Fable so a cheaper model can execute it in a separate session (pairs with /implement-plan)
argument-hint: "<project> | <item: qN, #issue, or text> — or a plain task description"
---

## Task

Produce a plan file that a less capable model (Opus/Sonnet) can execute **without judgment calls**. This session plans only. The pipeline: this command → `claude --model opus` → `/implement-plan`.

`$ARGUMENTS` takes two forms:

- **Queue form** — `<project> | <item>`: a vault project name, then a queue item (`qN` ID, `#issue` ref, or text fragment). The vault is `~/obsidian/SecondBrain`, reachable from any cwd via `permissions.additionalDirectories`.
- **Plain form** — a task description with no `|`. For work outside the vault's project system.

If empty, ask for it and stop.

## Steps (queue form)

1. **Resolve the item.** Find the line in `projects/<project>/Queue.md`, trying in order: a block ID (`q14`, `14` and `^q14` all mean the line ending in `^q14`), an issue ref (`#901` means the line carrying `(#901)`), else a text fragment. If a fragment matches several lines, list them with their `^qN` IDs and ask which. If nothing matches, say so and stop.

2. **Read what the vault already knows.** `projects/<project>.md` for the goal, current state and `repo:`. Then every note the queue line wikilinks, plus any audit, incident or plan note in `projects/<project>/` whose subject overlaps the item. This is the part you cannot skip — an item like "server stability" is meaningless without the incident write-ups behind it. Arrive at brainstorming knowing what is established (with note names), what you inferred, and what the vault does not settle.

3. **Mark planning in progress.** Set the queue line's state to `- [/]`. Do not change its lane; the lane changes when the plan exists.

4. **Refine requirements.** Invoke `superpowers:brainstorming` with the item — quote the queue line verbatim as the symptom (the user's phrasing encodes what they noticed; do not improve it) and bring the open questions from step 2 already drawn up. Resolve every ambiguity here, with the user; an ambiguity left in the plan becomes a judgment call for a model chosen precisely because it should not make them.

5. **Write the plan.** Invoke `superpowers:writing-plans`. Save to the vault: `projects/<project>/plans/YYYY-MM-DD-<topic>.md` (create `plans/` if missing). Frontmatter carries the vault's standard keys plus the backlink that lets `/sync` and `/implement-plan` trace it:

   ```yaml
   ---
   id: <unix-timestamp>-<4 letters>
   tags: [plan]
   queue: projects/<project>/Queue.md
   queue_item: <the queue line verbatim, markers included>
   ---
   ```

   The plan lives in the vault so it syncs between machines with the vault's own git backup, and so there is exactly one authority — never copy it into the repo.

6. **Stamp the queue line.** Append `→plan:[[<project>/plans/YYYY-MM-DD-<topic>]]` to the line, before the trailing `^qN` — the block ID stays the last token.

7. **Make it executor-grade.** Beyond the writing-plans format, every phase must have:
   - Exact file paths and function signatures for each change.
   - Verbatim commands for tests/lint/typecheck with expected results.
   - Acceptance checks: observable behavior, not "should work".
   - A **stop-and-ask list** at the top of the plan. Minimum triggers: reality deviates from the plan (file moved, API changed), tests still failing after 2 fix attempts, ambiguous requirement discovered mid-phase, any security-sensitive decision not spelled out in the plan.

8. **Self-check.** Reread the plan as if you were Sonnet with no context: any step where two reasonable implementations exist? Fix it or move the decision to the stop-and-ask list.

9. **Hand off.** Print exactly this and stop:

   ```
   Plan ready: projects/<project>/plans/<file>.md  (^qN)
   Next: exit, then run from the repo
     claude --model opus     # sonnet if the plan is fully mechanical
     /implement-plan <project> | qN
   ```

## Steps (plain form)

Same as above minus everything queue-related: brainstorm (step 4), write the plan to `docs/plans/YYYY-MM-DD-<topic>.md` relative to cwd, make it executor-grade (step 7), self-check (step 8). NEVER commit a `docs/plans/` plan (global rule); add `docs/plans/` to `.git/info/exclude` if the repo doesn't ignore it. Hand off with the path form: `/implement-plan docs/plans/<file>.md`.

## Rules

- NO implementation in this session. No code edits, no branches, no commits. Writing the plan file and stamping the queue line are the only writes this command performs.
- Run from the repo being planned — the plan is grounded in real code, and brainstorming needs to read it.
- Model guidance for the handoff line: suggest `sonnet` when every phase is mechanical (renames, config plumbing, well-specified CRUD), `opus` when phases need minor local decisions.
