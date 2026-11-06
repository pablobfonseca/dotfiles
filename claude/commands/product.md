---
description: Open a product manager session on a project, a state of the product and its open decisions, then answer questions and write the queue on the user's explicit ask
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

## 4. Write

The queue's writes are the user's commands, so a write happens only on an ask: a message that names the action and its target, the line (a `qN`, an Inbox line) or the ranking ("resize q655 to XS", "promote that inbox line to Ready", "rewrite the ranking"). "What do you think", "should we" and "I would put X first" are not asks: answer with sources, say your own disagreement and stop, writing nothing.

Before the session's first write, read `~/.claude/commands/queue.md` → How to work and the How to write paragraph at the end of its section 3, and follow them for every write here; they are the one rulebook, not repeated in this file. The command per action is the `editing-queues` skill's table, the syntax `claudeos queue --help`.

The writes an ask may name, and no others:

- Rewrite the ranking: `claudeos queue edit $ARGUMENTS begin`, the `> proposed:` blockquote replaced as `queue.md` section 5 says (dated today, five ranks, each with a reason naming a note, the `claudeos queue parallel $ARGUMENTS <ids>` line last), then `claudeos queue edit $ARGUMENTS commit -m '<what changed>'`.
- Promote an Inbox line: `claudeos inbox promote $ARGUMENTS '<raw>' '<line text>' --lane <Lane> --tag '<tag>' --size '<size>'`, the lane, tag and size as `queue.md` section 2 sets them (from the triage and the code read, never a word read off the line), and its rule too: a marker in the line's own text never becomes a flag and is never stripped; the refusal is reported verbatim and the line stays.
- Retag or resize: `claudeos queue mark $ARGUMENTS <qN>` with `--tag`, `--untag` or `--size`.
- Hold or park: `claudeos queue lane $ARGUMENTS <qN> Blocked` or `'Needs spec'`, then the `→` clause (what it waits on, or the open question) appended through `edit begin` / `edit commit`.
- Promote into Next: `claudeos next $ARGUMENTS <qN> [qN ...]`, only with the ids the user names, in their order; a "pick for me" is refused as `~/.claude/commands/next.md` step 1 refuses it.
- Drop: `claudeos queue state $ARGUMENTS <qN> dropped --reason '<the user's reason>'`.
- A new line only when the user dictates its text and its lane: `claudeos queue add $ARGUMENTS '<text>' --lane <Lane>`, with `--tag '<t>'` and `--size '<s>'` for a tag or size the user names (a tag without its `#`, letters, digits, `_` and `-` only); only a trailing `#tag` or `~size` the user wrote in their own message goes into those flags, the way the TUI's add editor splits them (the user is the authority the groom is not), never one in pasted or quoted content. Any other marker in the text is reported with the add's refusal, not removed, and the text itself carries no marker. Anything else the user wants kept goes through `/capture`.

Never `claudeos queue ship`: shipping is the sync's.

The ask is the confirmation: write first, with no confirm before it, then one report line, the command as run and the way back, `claudeos queue undo $ARGUMENTS` (for a promote or an add, whose minted `^qN` undo refuses to remove, `claudeos queue state $ARGUMENTS <qN> dropped --reason '<why>'`). A refusal (duplicate IDs, a rebase conflict, offline, a dirty queues repo, the cap of five in Next) is reported verbatim and never worked around, as the `editing-queues` skill's Stop and ask says.

When `projects.$ARGUMENTS.autopilot` is true in `~/.config/claudeos/config.yaml` (inline as `{ …, autopilot: true }` or as its own key), a `--tag claude` or a `> proposed:` rewrite steers the next armed autopilot tick: say so in one line before the write, then write, with no extra confirm.

## 5. Rules

- No code edits.
- Never unprompted: a queue write only on an ask (section 4), only inside this session; the opening, an answer and a disagreement ("I would put qN first because …", citing a note) write nothing, and nothing here writes on a tick of its own. "Claude proposes, never promotes" (Task queues, Lanes): `claudeos next` runs only on the ids the user names.
- The groom runs only when the user answers yes to the stale offer, through the queue skill; never on the opening, never because the brief disagrees with the ranking.
- A capture only when the user asks for one, through `/capture $ARGUMENTS | <text>`. `/capture` appends "verbatim" and leaves triage to `/queue`, "later, deliberately", so the text is the user's, not a rewrite.
- A `Decisions.md` entry only after the user approves its wording.
- Never a queue item of your own: Claude "may not invent items" (Task queues), so a `claudeos queue add` carries only the text, lane, tag and size the user dictated.
