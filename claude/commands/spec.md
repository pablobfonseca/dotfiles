---
description: Turn a queue item into a ready-to-run /fable-plan brief
argument-hint: <project name> | <item: qN, #issue, or text>
---

Compose the brief that `/fable-plan` should receive for one queue item. Arguments: `$ARGUMENTS` — project name, then the item (`qN` ID, `#issue`, or text fragment). The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd.

**This command does not plan.** `/fable-plan` plans, on Fable, in its own session — the model is chosen at session start, so no command can delegate to it in-process. What this command does is make `/fable-plan`'s brainstorming step cheap by handing it everything the vault already knows, so it starts informed instead of interrogating you about context you wrote down months ago.

Writes performed: the queue line's state marker, and nothing else.

## 1. Resolve the item

- Find the line in `projects/<project>/Queue.md`, trying in order: a block ID (`q14`, `14` and `^q14` all mean the line ending in `^q14`), an issue ref (`#901` means the line carrying `(#901)`), else a text fragment. If a fragment matches several lines, list them with their `^qN` IDs and ask which. If nothing matches, say so and stop.
- Read `projects/<project>.md` for the goal, current state and `repo:`.
- Read every note the line wikilinks, plus any audit, incident or plan note in `projects/<project>/` whose subject overlaps the item. This is the part you cannot skip — an item like "server stability" is meaningless without the two incident write-ups behind it.

## 2. Assemble the brief

The brief is prose, not a form. It must carry:

- **The symptom or end state, in the user's own words.** Quote the queue line verbatim first. Their phrasing encodes what they noticed; do not improve it.
- **What the vault already establishes** — with note names. Prior incidents, audit findings, design decisions, related shipped work. Distinguish what is written down from what you inferred.
- **What the vault does not settle.** Name the open questions explicitly. `/fable-plan` resolves ambiguity with the user during brainstorming; your job is to arrive with the list already drawn up, not to pre-empt it.
- **Blast radius**, if the notes support a claim about it — what else reads the thing being changed. For Tribemap, anything touching ingest or page roles feeds classification, briefings and the KB.
- **Known constraints**: eval gates, migration or backfill requirements, security-sensitive surfaces.

Do not write acceptance criteria, file paths, phases or a stop-and-ask list. `/fable-plan` produces those from the code, and it will do it better than you can from notes.

## 3. Add the backlink trailer

End the brief with exactly this, so the plan can be traced back without anyone remembering to record it:

```
Queue: projects/<project>/Queue.md
Queue-item: <the queue line verbatim, markers included>
Include both lines in the plan file's frontmatter as queue: and queue_item:.
```

`/sync` uses that frontmatter to reconcile the queue automatically. Without it, the plan is an orphan.

## 4. Mark and hand off

Set the queue line's state to `- [/]` — planning is in progress. Do not change its lane; the lane changes when a plan exists, and `/sync` handles that.

Then print exactly:

```
Brief ready for: <queue line>

Next: exit, then run from the repo <repo>
  claude --model fable
  /fable-plan "<the brief>"

Then: /implement-plan, and /sync <project> once a PR exists.
```

## 5. Report

Which notes you read, what the brief asserts as established versus inferred, and the open questions you are handing to brainstorming. If the vault turned out to have nothing useful on the item, say that plainly — a brief that pads thin context with confident-sounding filler is worse than a one-line brief.
