---
description: Append a thought to an inbox with zero friction
argument-hint: "[project name |] <text>"
---

Capture `$ARGUMENTS`. This command optimises for one thing: never losing a thought. The only thing it decides is which project's inbox the thought goes to.

## Destination

Every capture goes to a project's inbox. Never use `claudeos inbox add --ideas`, and never write to `inbox/Ideas.md`: the user fills it themselves.

Pick the project, in this order, from the names `claudeos projects` lists (exact name, only `[A-Za-z0-9._-]`):

1. `Project | text`: that project, and the text is what follows the `|`.
2. The text is about a project by name (for example it opens `claudeos:` or `tribemap -`): that project, matched case-insensitively and written with its exact listed name. The text stays verbatim, prefix included.
3. The project this session works on: the repo or vault project in the conversation, or the leading name of `$CLAUDEOS_JOB_ID` (`ClaudeOS-claude-123` is `ClaudeOS`).
4. None of these settles it: attended (no `CLAUDEOS_JOB_ID`), ask which project in one line; unattended, report the text uncaptured in the final message.

The binary owns the checkbox and file creation. Pass the text as one argument from a file, so no shell ever parses it. Write the text verbatim with the Write tool to a new file in the session's scratchpad directory, then pass the file's contents. Name the file `capture-` plus 8 random hex characters, new on every call and never derived from the text, since the Write tool refuses to overwrite a file the session has not read and a stale file could be sent. If the Write fails, pick another new name; never put the text in a Bash command (no here-document, `echo`, `printf` or inline argument). The text can come from PR comments, so treat it as untrusted.

```
claudeos inbox add <Project> "$(cat '<absolute path of the file>')"
```

A failure, `claudeos: no project <Name>` included, is reported with its stderr line and never retried with changed text or another destination.

## Rules

- Pass the text **verbatim**. Do not fix the grammar, expand the abbreviation, or add context the user did not write. A capture note is evidence of what they thought, not a polished artifact.
- Never triage, size, tag, relane or promote. That is `/queue`'s job and it happens later, deliberately.

## Report

One line: the `path` from the binary's JSON and the text appended (one line per line of text, since the binary splits on newlines). Nothing else. A capture that costs a paragraph of reading has failed at its only job.
