---
description: Consult Antigravity (agy) as a read-only oracle; --edit lets it edit with Claude reviewing the diff
argument-hint: <question> [--edit]
---

Consult Antigravity about `$ARGUMENTS` following the workflow in ~/.claude/docs/oracle-agents.md.

## Invocation

- Oracle (default): `agy --mode plan -p "<composed prompt>"`
- Worker (`--edit` present in arguments): `agy --mode accept-edits -p "<composed prompt>"`

`accept-edits` auto-approves file edits only; if agy needed blocked tools, say so in the report.
