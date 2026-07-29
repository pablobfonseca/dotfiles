---
description: Reconcile a project's queue against plans, PRs and GitHub issues
argument-hint: <project name> [--repo owner/name]
---

Make `projects/$ARGUMENTS/Queue.md` true. This command reads artifacts — plan files, PRs, issues — and writes what they prove back onto the queue. It never asks you what happened.

Run it from the repo. The vault is `~/obsidian/SecondBrain`, available in every session via `permissions.additionalDirectories` — no `--add-dir` needed.

## 1. Preflight

- `gh auth status`. If unauthenticated, skip the GitHub half and say so rather than failing the whole run.
- Resolve the repo: `--repo`, else `repo:` in `projects/$ARGUMENTS.md` frontmatter, else ask. Never guess.
- Read `CLAUDE.md` → Task queues. Its invariants bind you, especially: nothing is deleted, and issue refs are immutable.

## 2. Plans → queue

Scan `docs/plans/*.md` for frontmatter written by `/fable-plan`:

```yaml
queue: projects/<project>/Queue.md
queue_item: <the original queue line>
```

Match `queue_item:` to a queue line by its `^qN` block ID when the frontmatter carries one; fall back to verbatim text for older plans. For each match against this project's queue, write `→plan:docs/plans/<file>.md` onto the line and move it from `## Needs spec` to `## Ready`. Anything you append to a line (`→plan:`, `→pr:`, `(#N)`) goes before a trailing `^qN` — the block ID stays the last token. A plan existing is what makes an item ready — that is the whole contract.

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

```
gh issue list --repo <repo> --state all --limit 200 --json number,title,state,stateReason,url
```

- Closed issue, open line → `## Shipped` as `- [x]`. If `stateReason` is `not_planned`, make it `- [-]` with the reason instead; declined is not shipped.
- Open issue, line marked done → **report the disagreement, change nothing.** Never silently reopen.
- Referenced issue missing → flag it, leave the `(#N)` alone.
- Open issues with no queue line → list under `## Unqueued` in your report only, never in the file.

## 5. Precedence

When sources disagree, trust in this order: merged PR > closed issue > plan file > queue line. Say when you overrode something.

Never write a plan's contents into the vault. Plans live in `docs/plans/`, are deliberately uncommitted, and get revised mid-execution — a vault copy would be a second authority that drifts. The queue stores the path. Durable learnings reach the vault through `/harvest` when the project ships, not before.

## 6. Report

A table of every line that moved: item, lane before → after, and the artifact that justified it. Then, separately, the things needing your judgment — disagreements, orphan plans, closed-unmerged PRs, unqueued issues, and low-confidence title matches.

Do not commit unless asked.
