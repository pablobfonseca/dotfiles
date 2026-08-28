---
description: Groom a project's Queue.md and propose the next 5 by leverage
argument-hint: <project name>
---

Groom `projects/$ARGUMENTS/Queue.md`. The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd. Read the vault's `CLAUDE.md` → Task queues first; its invariants bind you. If the file does not exist, list `projects/` and stop.

## 0. Pull, then reconcile

Queue authority lives in the vault-queues repo (`~/.local/share/vault-queues`), not the vault: `queue-tool` pulls it before every read and pushes every write, so freshness and ID minting are its job, not yours. The vault's `projects/<P>/Queue.md` is a generated read-only view: never edit it. If `queue-tool` reports a rebase conflict or duplicate IDs, stop and report; never resolve either yourself.

Grooming a stale queue ranks fiction. Before anything else, run the full reconciliation defined in `~/.claude/commands/sync.md` (plans → queue, PRs → queue, issues → queue) — read that file and follow it; it is the single source of truth for reconciliation rules. If `gh` is unauthenticated, do the plans half and say the GitHub half was skipped. Merged work lands in `## Shipped` before you rank what's left.

## 1. Read the whole picture before touching a line

- `projects/$ARGUMENTS.md` — goal, status, next steps. This is what "leverage" is measured against.
- `queue-tool dump $ARGUMENTS` — the queue, parsed: every line's lane, state and markers as JSON, plus `duplicates`, `unstamped` and `next_id`. Trust this parse instead of reading the markers by eye; to change a line, use `queue-tool` rather than opening the vault's read-only view.
- `projects/$ARGUMENTS/Inbox.md` if present — loose capture that may contain promotable items.
- Every support note in `projects/$ARGUMENTS/` whose title suggests a plan, audit or incident. You cannot rank without knowing what is already specced.

## 2. Promote from Inbox

Anything in Inbox.md that names an observable symptom or a desired end state becomes a queue line. Delete the promoted line from Inbox.md outright — no "moved to Queue" annotation or breadcrumb; the queue line is the record. Prose, half-thoughts and reference material stay in Inbox.md. Say which items you promoted and leave Inbox.md's non-actionable content untouched. Promote with `queue-tool add $ARGUMENTS "<line text>" --lane <Lane>`; it stamps the `^qN` itself.

## 3. Groom each open line

In this order, and only these:

- **Stamp**: run `queue-tool stamp $ARGUMENTS`; it mints and pushes IDs atomically (and refuses offline, because minting against a stale remote is the two-machine race). IDs are immutable — never renumber, never reuse, never strip.
- **Split** anything that is two deliverables. Note the split in your report; each half gets its own fresh `^qN`, the original ID stays on the half closest to the original wording.
- **Size** unsized lines: `~XS` under an hour, `~S` a sitting, `~M` a day, `~L` needs decomposition.
- **Tag** with at most what applies: `#bug` `#feat` `#sec` `#ops`, plus `#claude` only if an agent could finish it unattended with no product decision to make.
- **Relane**: vague → `## Needs spec` with a `→` question naming what is undetermined; waiting on something → `## Blocked` with a `→` dependency; explicitly-not-now → `## Someday`.
- **Link** to any existing plan, audit or incident note that already covers the item.
- **Dedupe**: if two lines are the same work, merge them and keep every `(#N)` ref.

How to write: single-line changes use the atomic subcommands (`state`, `lane`, `mark`, `add`); anything free-form — splits, rewording, merges, the `> proposed:` blockquote — goes through `queue-tool edit $ARGUMENTS begin`, editing the printed file, then `queue-tool edit $ARGUMENTS commit -m "<what changed>"`.

Do not reword a line into something more abstract than the user wrote. Precision is the point; a groomed line should be *more* specific, never less.

## 4. Detect what is already done

For each open line, check the notes for evidence it shipped (a plan marked complete, an incident closed, an issue referenced as merged). If the evidence is solid, move it to `## Shipped` as `- [x]` and say why. If it is suggestive but not conclusive, leave it open and flag it in your report — do not guess a completion.

## 5. Propose the next 5

Replace the `> proposed:` blockquote under `## Next` with a fresh one, dated today. Five items, ranked, each with one or two sentences of *reasoning that cites a note* — not a restatement of the item.

Rank by leverage, roughly in this order of precedence:

1. Corrupts or loses data at the input (everything downstream inherits it)
2. Unblocks the project's stated critical path
3. Wrong output on the product's core promise
4. Already specced and user-facing (cheap real wins)
5. Written-up pain that has never been converted into work

Never move an item into `## Next` yourself. The blockquote is the whole deliverable.

## 6. Report

- What you promoted, split, resized, relaned, merged, or moved to Shipped — as a short list of before → after.
- Anything you deliberately left alone and why.
- Which lines are now the largest unknowns in the queue.

Every `queue-tool` mutation commits and pushes the authority repo itself and regenerates the vault view; there is nothing to commit in the vault for queue changes. Inbox.md edits still live in the vault as before.
