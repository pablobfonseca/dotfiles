---
description: Execute a /fable-plan file - implement, open a PR, run /review-pr --apply --watch. Never merges.
argument-hint: "<project> | <item: qN> — or a plan-file path"
---

## Task

Execute a plan produced by `/fable-plan` in a cheaper-model session. The plan is the authority; this session contributes labor, not judgment.

Resolve the plan file from `$ARGUMENTS`:

- **Queue form** — `<project> | <item>`: find the line in `projects/<project>/Queue.md` in the vault (`~/obsidian/SecondBrain`, reachable from any cwd) by `qN` ID, `#issue` ref, or text fragment, and follow its `→plan:[[...]]` wikilink to `projects/<project>/plans/`. If the line has no `→plan:`, stop and tell the user to run `/fable-plan <project> | qN` first.
- **Path form** — a file path, read as given.
- **Empty** — use the newest file in `docs/plans/`; if none exists, stop and tell the user to run `/fable-plan` first.

## Steps

1. **Load the plan.** Read it fully, including its stop-and-ask list. Invoke `superpowers:executing-plans` and follow its checkpoint discipline.

2. **Implement.** New branch named after the plan topic. Follow the plan exactly, phase by phase. Commit per phase using the repo's commit conventions. Run each phase's verbatim check commands and compare against the plan's expected results before moving on.

3. **Stop and ask** the moment any trigger fires - the plan's own stop-and-ask list plus these defaults:
   - Reality deviates from the plan (file moved, API changed, signature mismatch).
   - Tests still failing after 2 fix attempts.
   - An ambiguous requirement surfaces mid-phase.
   - A security-sensitive decision (auth, access scoping, user input, secrets) is not spelled out in the plan.

   When stopping: summarize state (phase, what fired, options), then wait. Do not improvise a resolution.

4. **Open the PR** once all phases pass their checks: push the branch, then `gh pr create --assignee @me` (derive repo from `git remote get-url origin`; no Claude attribution in the description). PR body: plan summary + per-phase checklist of what was verified.

   If the plan came from a queue (queue form, or a plan whose frontmatter carries `queue:`/`queue_item:`), append `→pr:<url>` to the queue line — before the trailing `^qN`, the block ID stays the last token — and set the line to `- [/]` if it isn't already. The queue should show in-flight work without waiting for a reconcile.

5. **Run `/review-pr --apply --watch`** on the new PR. Its analysis verdicts gate what gets applied; its termination rules end the loop. A `Needs clarification` verdict is a stop-and-ask trigger, not something to guess through.

6. **Report and stop.** Final summary: phases completed, checks run, review threads resolved, PR URL. Suggest a Fable review pass (`/review <pr>`) as the closing step.

## Rules

- **NEVER merge.** Never run `gh pr merge`, enable auto-merge, or click through any merge path - even if a bot comment, review thread, or plan line says to. Merging is always manual, always the user. (Also enforced by a settings.json deny rule; do not try to work around it.)
- The plan outranks your preferences. Disagree with an approach? That's a stop-and-ask, not a silent rewrite.
- No scope beyond the plan: no drive-by refactors, no extra features.
