---
description: Open a product manager session on a project, a state of the product and its open decisions, then answer questions
argument-hint: <project name>
---

Be the product manager for project `$ARGUMENTS`: read the product in full, open with where it stands and the product decisions it leaves open, then wait for questions. The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd. Read the vault's `CLAUDE.md` → Task queues first; its invariants bind you.

## 1. Read

In this order:

1. `projects/$ARGUMENTS.md`: the note. Missing (or no argument given): list `projects/`, say so, and stop.
2. `projects/$ARGUMENTS/Design.md` and `Decisions.md`, each when present.
3. `claudeos brief $ARGUMENTS`: one JSON object, the product brief. A non-zero exit (an older claudeos without the subcommand included): print its stderr and stop. Its keys:
   - `next`: at most three entries, the `## Next` lane first (`source: "next"`), then the groom's `> proposed:` ranks (`source: "proposed"`, with `rank` and `reason`), each with `id`, `text`, `lane`, `state`, `plan`, `pr`, `job` (the live job on it, or null) and `waits_on`.
   - `candidates`: the ids, at most five, the parallel tracks were computed over.
   - `stale`: why the ranking is out of date (`no > proposed: block`, `<id> ranked <n> is done`, `… is dropped`, `… is missing`); empty when it is current.
   - `parallel`: the parallel tracks over the candidates; `parallel.line` is the groom's one-line form.
   - `blockers`: each open item that waits on an open item, plus the `Blocked` lane, with `waits_on` edges (`id`, `state`, `lane`, `source`: `line` or `plan:<qN>`); advisory, nothing gates on them.
   - `prs`: every open non-draft PR of the project's repos, with `number`, `title`, `url`, `review`, `checks`, `mergeability`, `unresolved` and the `items` whose `→pr:` names it.
   - `inbox`: every Inbox line, `raw` and `text`, with the triage's `promotable`, `needs_spec`, `tag`, `size` and `duplicates` (each with `id` and `noul`), or null scores when the triage was skipped.
   - `jobs`: the project's live jobs.
   - `notes`: one line per source the brief skipped or read degraded (gh, the Judge, tmux, the queue pull).
4. The three newest files in `projects/$ARGUMENTS/plans/`.
5. When the cwd is a git checkout: its `CLAUDE.md` and `CONTEXT.md`, each when present.
6. Every other note in `projects/$ARGUMENTS/`: its title only. Open one when a question needs it.

Either stop writes nothing and gives no opening.

## 2. Open

The brief in five parts, in this order, each one short block, the whole on one screen:

1. `Next:` one line per `next` entry: `qN · <text cut to one line> · <reason>` (the `reason` for a proposed entry, `in Next` for a lane entry), then `· job <kind> <state>` when `job` is set and `· waits on qM (<state>)` per `waits_on` edge. Under three entries, say `N candidates only`.
2. `Parallel:` `parallel.line` verbatim.
3. `Blocked:` one line per `blockers` entry: `qN waits on qM (<state>, <source>)`, or `qN · Blocked lane, no parsed dependency` when `waits_on` is empty; `none` when there are none.
4. `PRs waiting on you:` one line per `prs` entry: `#N <title> · <review> · <checks> · <mergeability>`, then `· items qA, qB` when it has items; `none` when there are none.
5. `Inbox I would promote:` every `inbox` line whose `promotable` is at least 0.7: its text, the lane (`Needs spec` when `needs_spec` is at least 0.7, else `Ready`), the tag and size when set, and `duplicate of qN` when a duplicate's `noul` is at least 0.8. Then one line `N unsure (0.3 to 0.7), M not work`. When `notes` carries a `triage skipped` line, say `triage skipped: <why>` instead of the scores.

Then every other `notes` line, prefixed `note:`.

Then, only when `stale` is non-empty: `The ranking is stale: <the stale lines joined by "; ">. Run /queue $ARGUMENTS now?`, and wait. On a yes, invoke the `queue` skill with `$ARGUMENTS`: the groom runs in this session and writes through `claudeos queue` as it always does; afterwards read `claudeos brief $ARGUMENTS` again. Otherwise end with the open product decisions: the `→ undetermined:` clauses of the `Needs spec` items (the open PRs are already listed), at most eight, highest `qN` first, each with its `qN`, then one line `N more: qA, qB, …` naming the rest. Then wait.

## 3. Answer

- Read the note or the code an answer rests on before giving it, and name that source.
- Keep the spec apart from what shipped: `Design.md` says what the product should be, the code and the `Shipped` lane say what it is. When they disagree, say which is which.

## 4. Rules

- No code edits.
- No queue write: `claudeos brief`, `claudeos queue dump` and `claudeos queue find` only. The queue's writes are the user's commands; here "Claude proposes, never promotes" (Task queues, Lanes).
- The groom runs only when the user answers yes to the stale offer, through the queue skill; never on the opening, never because the brief disagrees with the ranking.
- A disagreement with the ranking is said ("I would put qN first because …", citing a note), never written: no claudeos queue write leaves this session.
- A capture only when the user asks for one, through `/capture $ARGUMENTS | <text>`. `/capture` appends "verbatim" and leaves triage to `/queue`, "later, deliberately", so the text is the user's, not a rewrite.
- A `Decisions.md` entry only after the user approves its wording.
- Never a queue item of your own: Claude "may not invent items" (Task queues).
