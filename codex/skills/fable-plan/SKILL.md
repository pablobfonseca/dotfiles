---
name: fable-plan
description: Plan a task so a cheaper model can execute it in a separate session (pairs with $implement-plan). Use when the user runs $fable-plan with a project and queue item or a task description.
argument-hint: "<project> | <item: qN, #issue, or text> — or a plain task description [--notes <text…>]"
disable-model-invocation: true
---
## Task

Produce a plan file that a less capable model can execute **without judgment calls**. This session plans only. The pipeline: this skill, then a fresh session running `$implement-plan` on Codex or `/implement-plan` on Claude Code.

This is the Codex copy of `~/.dotfiles/claude/commands/fable-plan.md`, rewritten where that file calls Claude Code tools. The two change together.

`$ARGUMENTS` takes two forms:

- **Queue form**: `<project> | <item>`: a vault project name, then a queue item (`qN` ID, `#issue` ref, or text fragment). The vault is `~/obsidian/SecondBrain`.
- **Plain form**: a task description with no `|`. For work outside the vault's project system.

If empty, ask for it and stop.

## Flags

Check these before step 1, on the arguments as given.

- `--council`, `--critics` (either with or without `=<value>`) and `--auto` run on Claude only. When the arguments carry one, print exactly `<flag> runs on Claude only for now: run /fable-plan <the arguments as given> in a Claude Code session.`, with the first such flag as `<flag>`, and stop. Read nothing, write nothing, mark nothing.
- `--notes` takes everything after it, verbatim, to the end of the arguments. See **--notes**.

## Sandbox

The vault and the `claudeos queue` commands sit outside the workspace. When a read of `~/obsidian/SecondBrain`, a `claudeos queue` command or the write of the plan file needs an escalation, ask for it and wait. Never work around a refused escalation, never edit a `Queue.md` by hand (a guard refuses it), and never pass or suggest sandbox or approval flags.

## Steps (queue form)

1. **Resolve the item.** `claudeos queue find <project> <item>` resolves a block ID (`q14`, `14` and `^q14` all mean the line ending in `^q14`), an issue ref (`#901` means the line carrying `(#901)`), or a text fragment, and returns the line parsed as JSON. If a fragment matches several lines it lists them with their `^qN` IDs; relay that and ask which. If nothing matches, say so and stop.

2. **Read what the vault already knows.** `projects/<project>.md` for the goal, current state and `repo:`. Then every note the queue line wikilinks, plus any audit, incident or plan note in `projects/<project>/` whose subject overlaps the item. This is the part you cannot skip: an item like "server stability" is meaningless without the incident write-ups behind it. Arrive at step 5 knowing what is established (with note names), what you inferred, and what the vault does not settle.

3. **Scan the rest of the queue.** `claudeos queue dump <project>`, then read every open line. Collect items that share a file, surface, subsystem, root cause, or provenance (same PR review, same audit) with the target. The wording may share nothing; the connection is structural. These are input to step 5, never silent inclusions.

4. **Mark planning in progress.** `claudeos queue state <project> <qN> wip`. Do not change its lane; the lane changes when the plan exists.

5. **Refine requirements, with the user.** Read the code the item touches first. Then, in this order:

   1. Write one message that quotes the queue line verbatim as the symptom (the user's phrasing encodes what they noticed; do not improve it), quotes the `--notes` text verbatim beside it when given, lists what is established (with note names), what you inferred, and what is not settled, and lists the related candidates from step 3 with a suggested verdict each (bundle, sequence, or leave alone; the call is the user's). Right after the queue line and the notes, and before the established list, the message carries one line, `Objection: <one sentence>`: the strongest objection to the approach the queue line states (in plain form, the task description) and a simpler alternative. It is there on every plan, with no `No objection` variant. When the line is a bare symptom with no stated approach, object to the item as scoped: why not do it, or a smaller cut. It is not one of sub-step 2's questions and asks for no ruling: the user takes it up or ignores it, and silence means the stated approach stands.
   2. In the same message, ask every open question at once, numbered. Each question offers two to four concrete options with one line of trade-off each, the recommended option first and marked `(recommended)`. Ask only what the queue line, the notes, the vault and the code do not settle. Use the session's question tool when it has one; otherwise ask in plain text.
   3. End the turn and wait for the answers. Do not proceed on a guess.
   4. When the answers are in, write one message with the design: what changes, in which files and functions by name, what stays untouched and why, and every decision you are proposing that the user has not made yet, numbered. Ask for an explicit yes. End the turn and wait.
   5. No plan file is written, and nothing but step 4's `wip` is stamped, before that yes. A correction goes back to sub-step 4 with the design revised.

   Resolve every ambiguity here. An ambiguity left in the plan becomes a judgment call for a model chosen precisely because it should not make them. An ambiguity discovered while writing the plan is a new question to the user, not a default.

6. **Write the plan.** Pick the shape from **Plan shapes** first: size `XS` or `S` is short, anything else is full. Save to the vault: `projects/<project>/plans/YYYY-MM-DD-<topic>.md` (create `plans/` if missing). Frontmatter carries the vault's standard keys plus the backlink that lets `/sync` and `$implement-plan` trace it:

   ```yaml
   ---
   id: <unix-timestamp>-<4 letters>
   tags: [plan]
   queue: projects/<project>/Queue.md
   queue_item: <the queue line verbatim, markers included>
   model: opus | sonnet
   ---
   ```

   `model:` is the Claude executor model this plan is graded for, `opus` or `sonnet`, nothing else, chosen by the rule in Rules. A Claude implement reads it; a Codex implement runs on its own default.

   The full shape, in this order:

   - `# <title> (^qN) Implementation Plan`
   - One header line, with `<harness>` the skill the repo's `CLAUDE.md` or `AGENTS.md` harness section names, or `no harness skill: the session writes and verifies each phase` when it names none: `> **For agentic workers:** execute via `/implement-plan <project> | qN` from `<repo root>`; the repo's harness skill (`<harness>`) writes and verifies each phase. Steps use checkbox (`- [ ]`) syntax for tracking.` followed by `Read first:` and the files by path. Name no other execution skill anywhere in the plan.
   - With `--notes`, one `**Launch notes:**` line carrying them verbatim.
   - One `**Objection:**` line: step 5's sentence verbatim, then `Outcome:` with `taken` and what changed, `overruled` and the user's reason, or `not taken up`.
   - `**Goal:**` one sentence of observable behaviour. `**Architecture:**` two or three sentences. `**Tech Stack:**` versions as installed. `**Spec:**` the spec sections and decision-log lines the plan argues from.
   - `## Global Constraints`: the repo's gate command, the branch name, what is never touched, one line each.
   - `## Stop and ask`: the numbered triggers. Minimum: reality deviates from the plan (file moved, API changed), tests still failing after 2 fix attempts, an ambiguous requirement discovered mid-phase, any security-sensitive decision not spelled out in the plan.
   - `## Decisions`: a table of every decision step 5 settled, each with what was rejected.
   - `## Related queue items`: every candidate `^qN` from step 3 with a verdict: `bundled (rides this PR)`, `successor`, `out of scope: <why>`, or `checked, unrelated`. No candidates: write `none found`, so silence is distinguishable from a skipped scan.
   - One `### Task N: <deliverable>` per commit, each with `**Files:**` (exact paths, Create, Modify or Test), `**Interfaces:**` (what it consumes and produces, exact signatures), then `- [ ] **Step N: …**` lines. A step is one action: write the failing test (the test code in full), run it (the command and the expected failure), write the implementation (the code in full), run it (the command and the expected pass), commit (the `git add` by path and the message). Each task ends with `**Acceptance:**`, an observable check.
   - `## PR`: the branch, the body's first line `Closes <project> ^qN.`, what the body lists.
   - `## Self-review`: what you verified against the working tree and when.

   Never write in a plan: `TBD`, `TODO`, "add appropriate error handling", "write tests for the above", "similar to Task N", a step that says what to do without the code or the command, or a name no task defines.

   The plan lives in the vault so it syncs between machines with the vault's own git backup, and so there is exactly one authority. Never copy it into the repo.

   When the item amends the project's spec, the plan edits the section the change belongs to, in place, never a dated note appended at the end; the dated why (what was decided, why, what it supersedes, the `qN` that carried it) goes to `Decisions.md` beside the spec.

7. **Stamp the queue line.** Size the item from the written plan on the vault scale (`XS`, `S`, `M`, `L`: the shape's own size for a short plan, or the size step 5 settled for a full one). Decide `#claude`: set it when the written plan carries only the default stop-and-ask triggers and leaves no decision open; clear a groom-time `#claude` when it does not (an item-specific stop trigger, or a short plan that hands a decision to the executor). `model:` stays an independent choice. Stamp plan, size and tag in the one call: `claudeos queue mark <project> <qN> --plan '[[<project>/plans/YYYY-MM-DD-<topic>]]' --size <XS|S|M|L> [--tag claude | --untag claude]`. Print one line: `Sized <old> → <new>, #claude <set|cleared|unchanged>.` Run the same `mark` for every line the user bundled in step 5, but with `--plan` only: a bundled line rides the primary item's plan and keeps its own size and tags; the plan's `queue_item:` stays the primary line only.

8. **Make it executor-grade.** For the full shape (the short shape's bar is in **Plan shapes**), every task must have:
   - Exact file paths and function signatures for each change.
   - Verbatim commands for tests, lint and typecheck with expected results.
   - Acceptance checks: observable behaviour, not "should work".
   - Every path, function and command checked against the working tree in this session, not recalled.

9. **Self-check.** Reread the plan as the executor with no context: any step where two reasonable implementations exist? Fix it or move the decision to the stop-and-ask list. If the pass changed the tasks enough to change the executor grade, update the plan's `model:` before handing off. For a short plan, ask **Plan shapes**' question instead and run its line check: `awk 'c>=2{n++} /^---$/{c++} END{print n}' <plan>` prints at most `60`, and `grep -c '^```' <plan>` prints `0`.

10. **Hand off.** Print exactly this and stop, with `<model>` replaced by the value written to `model:` in step 6:

   ```
   Plan ready: projects/<project>/plans/<file>.md  (^qN)
   Next: exit, then run from the repo
     codex
     $implement-plan <project> | qN
   On Claude Code instead:
     claude --model <model>
     /implement-plan <project> | qN
   ```

## Steps (plain form)

Same as above minus everything queue-related: refine requirements (step 5), size the task in one line and pick the shape (**Plan shapes**), write the plan to `docs/plans/YYYY-MM-DD-<topic>.md` relative to cwd, make it executor-grade (step 8), self-check (step 9). The step 6 header line names `/implement-plan docs/plans/<file>.md` in place of the queue form. Hand off with the path form in both blocks: `$implement-plan docs/plans/<file>.md` and `/implement-plan docs/plans/<file>.md`.

## Plan shapes

The item's size picks the plan's shape. Queue form: the `size` key of `claudeos queue find`'s JSON; `XS` or `S` is **short**, anything else (`M` and up, or no size) is **full**. Plain form: size the task on the same scale in one line before step 6 (`Sized ~S: two files, no new interface`) and pick from that. When step 2 or 5 shows that an `S` carries a new interface, more than about three files, or security or data-integrity weight, write the full shape and say why in one line under the plan's header. Never the reverse: an item sized `M` or above never gets the short shape. The size step 5 settles is the size the plan writes back in step 7, so the shape and the queue line agree; a size that lands on `L` mid-brainstorm means the item needs decomposition, not a plan: stop before step 6 and say so.

**Full** is the shape steps 6, 8 and 9 describe.

**Short** hands judgment back to the executor: it records the decisions step 5 settled and leaves the instructions out. The frontmatter is the full shape's, unchanged, because tools read it. The body below the frontmatter is at most 60 lines and has no fenced block. Its sections, in order:

- The `# <title> (^qN) Implementation Plan` heading, then one `> **For agentic workers:**` line carrying the `/implement-plan <project> | qN` command and the repo to run it from, the files to read first by name (no line numbers), and the sentence `Short plan: where it is silent, decide locally and list each choice in the PR body.`
- **Goal:** one sentence of observable behaviour. With `--notes`, the `**Launch notes:**` line under it. Then the `**Objection:**` line, as step 6 words it; the 60-line cap is unchanged.
- **Approach:** two to four sentences: what changes, in which files and functions by name, what stays untouched and why.
- **Stop and ask:** only triggers specific to this item; omit the section when there are none, the implement's defaults stand.
- **Related queue items**, exactly as step 6 requires.
- One `### Task N: <deliverable>` heading per commit, each holding one `- [ ]` line per deliverable: the code change by file and function name, the test by name and the assertion it makes, the spec, decision, handbook or changelog edit by file and section. The executor writes the code, the test and the wording.
- **Acceptance:** one block for the whole plan: the observable check that proves the goal, the tests named above passing, and the repo's gate.

Dropped from the short shape, deliberately: line numbers, quoted code and quoted prose, per-task steps, commands and expected outputs, per-task acceptance, **Global Constraints**, **Tech Stack**, **Spec**, the PR section and the self-review section. A short plan that needs any of them to be understood is a full plan.

For the short shape, executor-grade means: every file and function it names exists, the acceptance is observable, and every decision step 5 settled is written down. Step 9's question for it is not whether two implementations exist (they may, and the executor picks) but whether the executor knows which outcome proves it done and which decisions are not theirs to remake.

## --notes

Steers what step 5 opens with. `--notes` takes everything after it, verbatim, to the end of the arguments; it goes last.

- `--notes` with nothing after it: reply `--notes needs text` and stop.
- Step 5 opens by quoting the notes verbatim beside the queue line, before the first question. The notes settle what they cover; they are not additional requirements to relitigate, and the `Objection:` line, which follows them, does not reopen what they settle. A note that contradicts the project's spec or decision log is raised with the user, never silently followed.
- Step 6 records the notes verbatim on one `**Launch notes:**` line, since the job that launched this session does not store flags.

## Rules

- NO implementation in this session. No code edits, no branches, no commits. Writing the plan file and stamping the queue line are the only writes this skill performs.
- Run from the repo being planned: the plan is grounded in real code, and step 5 needs to read it.
- Executor model, one decision with two outputs: `sonnet` when every task is mechanical (renames, config plumbing, well-specified CRUD), `opus` when tasks need minor local decisions. Write it to `model:` in step 6 and print the same value in step 10's handoff; `opus` and `sonnet` are the only values `model:` takes. Append a "bump thinking effort" note to the handoff only when tasks involve debugging or gnarly integration; otherwise say nothing about effort.
