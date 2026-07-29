---
description: Append a thought to an inbox with zero friction
argument-hint: [project name |] <text>
---

Capture `$ARGUMENTS`. This command optimises for one thing: never losing a thought. It asks nothing and decides nothing.

## Destination

The vault is `~/obsidian/SecondBrain`; both destinations below resolve there, whatever the cwd.

- If the text starts with a known project name followed by `|`, append to `projects/<project>/Inbox.md` under `## Raw`.
- Otherwise append to `inbox/Inbox dump.md`.
- If the target file does not exist, create it with the frontmatter from `CLAUDE.md`.

## Rules

- Append **verbatim**. Do not fix the grammar, expand the abbreviation, or add context the user did not write. A capture note is evidence of what they thought, not a polished artifact.
- Prefix with `- [ ] ` unless the text is plainly not work: a question or a bare URL stays a bare line. Erring toward the checkbox keeps `/queue` the single place where triage happens. The Raycast capture extension (`~/code/Playground/capture-obsidian`) applies the same rule; change both together.
- Never triage, size, tag, relane or promote. That is `/queue`'s job and it happens later, deliberately.
- Never touch any other line in the file.

## Report

One line: the file and the text appended. Nothing else — a capture that costs a paragraph of reading has failed at its only job.
