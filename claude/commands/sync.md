---
description: Reconcile a project's queue against plans, PRs and GitHub issues
argument-hint: <project name> [--repo owner/name]
---

Make `projects/$ARGUMENTS/Queue.md` true. This command reads artifacts — plan files, PRs, issues — and writes what they prove back onto the queue. It never asks you what happened.

Run it from anywhere: plans live in the vault and PRs/issues come via `gh`, so no repo checkout is needed. The vault is `~/obsidian/SecondBrain`, available in every session via `permissions.additionalDirectories`. `/queue` runs this same reconciliation as its step 0, so a standalone `/sync` is only needed when you want the queue fresh without grooming it.

## 1. Preflight

- `gh auth status`. If unauthenticated, skip the GitHub half and say so rather than failing the whole run.
- Resolve the repo: `--repo`, else `repo:` in `projects/$ARGUMENTS.md` frontmatter, else ask. Never guess.
- Read `CLAUDE.md` → Task queues. Its invariants bind you, especially: nothing is deleted, and issue refs are immutable.
- Run `~/.dotfiles/claude/scripts/queue-tool dump $ARGUMENTS` — the whole queue parsed as JSON (lane, state, markers, `^qN` per line); work from this instead of parsing Queue.md by hand. Its `duplicates` field is the duplicate-ID scan (line-ending IDs only; mid-line mentions in the proposed blockquote or wikilinks are references, not IDs) — the two-machine race can merge cleanly and leave silent duplicates. If found: make no writebacks to the duplicated IDs, and report the duplicate lines so the human can restamp one (the line with no inbound links or refs, normally). Never renumber yourself.

## 2. Plans → queue

Run `~/.dotfiles/claude/scripts/queue-tool plans $ARGUMENTS` — one pass over `projects/$ARGUMENTS/plans/*.md` extracting the frontmatter written by `/fable-plan` (plus `queue_item_id`, the `^qN` pulled from `queue_item:`); read a plan file itself only when its entry needs judgment:

```yaml
queue: projects/<project>/Queue.md
queue_item: <the original queue line>
```

Match `queue_item:` to a queue line by its `^qN` block ID when the frontmatter carries one; fall back to verbatim text for older plans. For each match against this project's queue, write `→plan:[[<project>/plans/<file>]]` onto the line and move it from `## Needs spec` to `## Ready`. Anything you append to a line (`→plan:`, `→pr:`, `(#N)`) goes before a trailing `^qN` — the block ID stays the last token. A plan existing is what makes an item ready — that is the whole contract.

Older lines carrying `→plan:docs/plans/…` refer to plans that lived uncommitted in a repo; treat the reference as historical and don't rewrite it.

Plans with no `queue_item:` are orphans: list them in your report so they can be adopted or deleted. Never invent a queue line to adopt one.

## 3. PRs → queue

```
gh pr list --repo <repo> --state all --limit 100 --json number,title,state,url,headRefName,body,mergedAt
```

Match PRs to queue lines by, in order of confidence: a `(#N)` issue ref the PR closes, a plan path named in the PR body, then branch-name or title overlap. **Only the first two are conclusive.** Report title-similarity matches as suggestions and leave those lines untouched — a plausible-looking name is not evidence.

- PR open → `- [/]`, append `→pr:<url>`.
- PR merged → move to `## Shipped` as `- [x]`, keeping `(#N)` and `→pr:`.
- PR closed unmerged → leave the item open, append nothing, and report it. Abandoned work is a decision for the user, not a state to infer.

## 4. Issues → queue

`/issue` is retired — no new refs are minted, but existing `(#N)` refs are immutable and still reconcile. Fetch only what the queue references, never a full listing:

- The referenced numbers are the dump's `issue` fields (step 1).
- `gh issue list --repo <repo> --state open --json number` — any referenced number in this set is still open; nothing to do for it.
- Each referenced number **not** in the open set: `gh issue view <n> --repo <repo> --json state,stateReason,url`.

Then:

- Closed issue, open line → `## Shipped` as `- [x]`. If `stateReason` is `not_planned`, make it `- [-]` with the reason instead; declined is not shipped.
- Open issue, line marked done → **report the disagreement, change nothing.** Never silently reopen.
- Referenced issue missing → flag it, leave the `(#N)` alone.

## 5. Precedence

When sources disagree, trust in this order: merged PR > closed issue > plan file > queue line. Say when you overrode something.

The plan file in `projects/<project>/plans/` is the single authority — never duplicate its contents onto the queue or into the repo. The queue stores the wikilink. Durable learnings reach the wiki through `/harvest` when the project ships, not before.

## 6. Report

A table of every line that moved: item, lane before → after, and the artifact that justified it. Then, separately, the things needing your judgment — disagreements, orphan plans, closed-unmerged PRs, and low-confidence title matches.

Do not commit unless asked.
