---
description: Promote queue items into ## Next, the human-owned lane
argument-hint: <project name> <qN> [qN ...]
---

Promote the named items in `$ARGUMENTS` into `## Next`. The human names the IDs; the binary moves them; you relay.

1. If no IDs were given, or the user asks you to "pick the best ones", "promote the top 3" or anything that delegates the choice: refuse plainly, and list what `/queue` last proposed (`queue-tool dump <project>` → `proposed`). This is the one lane an agent never fills on its own judgment.
2. Otherwise run `claudeos next <project> <qN> [qN ...]` with the IDs in the order given (that order is the leverage ranking) and print its output verbatim. It refuses, changing nothing, when an ID is unknown, in Shipped, done or dropped (a mistyped ID, almost always), in Needs spec (offer `/fable-plan <project> | <qN>` instead), or when the cap of five would be exceeded (it lists the occupants; the user decides what leaves, never demote anything yourself). An item already in Next is a no-op and says so.
3. Leave the `> proposed:` blockquote alone; `/queue` rewrites it.
