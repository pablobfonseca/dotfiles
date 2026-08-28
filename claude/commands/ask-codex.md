---
description: Consult Codex as a read-only oracle; --edit lets it edit with Claude reviewing the diff
argument-hint: <question> [--edit]
---

Consult Codex about `$ARGUMENTS` following the workflow in ~/.claude/docs/oracle-agents.md.

## Invocation

- Oracle (default): `codex exec -s read-only --color never "<composed prompt>"`
- Worker (`--edit` present in arguments): `codex exec -s workspace-write --color never "<composed prompt>"`

Codex prints its event stream to stdout; the final agent message is the answer. For long runs add `-o <scratchpad file>` and read the clean final message from there.
