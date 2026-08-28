---
description: Consult Gemini CLI as a read-only oracle; --edit lets it edit with Claude reviewing the diff
argument-hint: <question> [--edit]
---

Consult Gemini about `$ARGUMENTS` following the workflow in ~/.claude/docs/oracle-agents.md.

## Invocation

- Oracle (default): `gemini --skip-trust --approval-mode plan -p "<composed prompt>"`
- Worker (`--edit` present in arguments): `gemini --skip-trust --approval-mode auto_edit -p "<composed prompt>"`

`--skip-trust` trusts the workspace for this run only; without it headless mode refuses untrusted folders.

`auto_edit` auto-approves file edits but not arbitrary shell; if Gemini needed blocked tools, say so in the report.
