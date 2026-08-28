---
description: Promote queue items into ## Next, the human-owned lane
argument-hint: <project name> <qN> [qN ...]
---

Promote the named items in `$ARGUMENTS` into `## Next`. The human names the IDs; you move them and report. This is the one lane an agent may never fill on its own judgment.

## 1. Parse

First token is the project. Every remaining token is an item ID (`q42`, `42` and `^q42` are all accepted). If no IDs were given, stop and say which items `/queue` last proposed — do **not** choose any yourself. Same if the user asks you to "pick the best ones", "promote the top 3", or anything else that delegates the decision: that is the whole point of the lane, and refusing is the correct answer. Say so plainly and list the candidates instead.

## 2. Show what is about to move

Run `queue-tool find <project> <qN>` for each ID and print the line's text, lane and state. A bare `^qN` pasted from a proposal is easy to get wrong by one digit, and a wrong promote quietly reprioritises the week.

Stop and ask, changing nothing, if any item:

- is already in `## Next` (say so; it is a no-op, not an error)
- sits in `## Shipped`, or is `- [x]` or `- [-]` — promoting finished or dropped work is almost always a mistyped ID
- is in `## Needs spec` — it has no plan yet, so it is not ready to be committed to. Offer `/fable-plan <project> | <qN>` instead. Promote it anyway only if the user says to after seeing the warning.

## 3. Check the cap

`## Next` holds **at most 5 items** (CLAUDE.md, Lanes). Count what is already there, add what is being promoted, and if the total exceeds five, stop and report the overflow with the current occupants listed. The user decides what leaves; never demote anything to make room.

## 4. Move them

```
queue-tool lane <project> <qN> Next
```

One call per ID, in the order the user gave them — that order is the leverage ranking. Each call is its own git transaction against the vault-queues repo and regenerates the vault view; there is nothing to commit in the vault afterwards.

Never edit `projects/<project>/Queue.md` directly — it is a generated read-only view. If `queue-tool` reports duplicate IDs or a rebase conflict, stop and report; neither is yours to resolve.

## 5. Report

One line per item: `^qN — <text>` and the lane it came from. Then the resulting contents of `## Next`, in order, so the week's commitment is visible in one place.

Leave the `> proposed:` blockquote alone. `/queue` rewrites it next time; it is a record of what was suggested, not a staging area.
