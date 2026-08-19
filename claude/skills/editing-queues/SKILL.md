---
name: editing-queues
description: Use when changing a project's task queue - marking an item done, wip or dropped, moving it between lanes, attaching a plan or PR link, promoting an item, or stamping ^qN block IDs - and always before editing any projects/*/Queue.md in the SecondBrain vault, in any repo or session.
---

# Editing Queues

## Overview

Queue authority is the private **vault-queues** repo (`~/.local/share/vault-queues`), not the vault. `queue-tool` runs every mutation as one git transaction (pull --rebase, mutate, commit, push, retry), which is what stops two machines silently losing each other's writes.

**The vault's `projects/<Project>/Queue.md` is a generated read-only view.** Editing it with Edit/Write looks like it worked, then gets overwritten on the next queue write.

## The rule

Never edit a `Queue.md` in the vault. Never hand-write a `^qN`. Every change goes through:

```bash
~/.dotfiles/claude/scripts/queue-tool --help
```

That help output is the syntax reference. Read it instead of guessing flags; this skill covers only the judgment it cannot encode.

**This holds in every session, including repo sessions where the vault's CLAUDE.md never loads.** Working in a product repo does not make the vault file editable.

## Which command

| Situation | Command |
|---|---|
| Starting work on an item | `state <P> <qN> wip` |
| Item shipped | `state <P> <qN> done` then `lane <P> <qN> Shipped` |
| Abandoning an item | `state <P> <qN> dropped --reason "<why>"` |
| Plan written for it | `mark <P> <qN> --plan '[[<P>/plans/<file>]]'` |
| PR opened | `mark <P> <qN> --pr <url>` |
| New item | `add <P> "<text>" --lane <Lane>` (mints the ID) |
| Reading state before deciding | `dump <P>` or `find <P> <qN\|#N\|text>` |
| Split, merge, reword, `> proposed:` blockquote | `edit <P> begin` → edit the printed path → `edit <P> commit -m "<what>"` |
| Undoing a queue change you just made | `log <P>` to see it, then `undo <P>` |

Single-line changes use the atomic subcommands. Reach for `edit` only when the change is genuinely free-form.

## Judgment the CLI does not encode

- **Nothing is deleted.** Completed items move to `Shipped`; abandoned ones become `dropped` with a reason. The queue is the audit trail.
- **`## Next` is human-owned.** Propose ranked candidates as a `> proposed:` blockquote and stop.
- **One line, one deliverable.** If an item is two things, split it and say so.
- **Vague is a lane, not a failure.** Underdetermined work goes to `Needs spec`, never a guessed scope.
- **Never invent items.** Grooming reshapes what is already there.

## Stop and ask

Report these, do not resolve them yourself:

- `duplicate IDs …` — a two-machine race left the same `^qN` twice. The human picks which line gets restamped.
- `rebase conflict in …` — the transaction aborted the rebase. Never hand-resolve it.
- `offline: this operation mints IDs` — `add` and `stamp` refuse offline on purpose. Wait for network; never hand-write the ID.
- `queues repo has uncommitted changes …` — an `edit begin` is in flight, or a previous edit was left unfinished. Finish it with `edit commit`, or discard it; never work around the refusal.
- `refusing: undoing … would remove ^qN` — `undo` will not free an ID for re-minting. Drop the line with `state <qN> dropped --reason "..."` instead.

## Common mistakes

| Mistake | What happens |
|---|---|
| `Edit` on the vault's `Queue.md` | Silently discarded on the next write |
| Appending `^qN` yourself | Collides with the other machine's next mint |
| Moving a line by hand to `Shipped` | Skips the transaction; use `state` then `lane` |
| Committing the vault for a queue change | The tool already pushed the authority repo |
