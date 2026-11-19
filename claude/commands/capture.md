---
description: Append a thought to an inbox with zero friction
argument-hint: [project name |] <text>
---

Capture `$ARGUMENTS`. This command optimises for one thing: never losing a thought. It asks nothing and decides nothing.

## Destination

The binary owns the destination, the checkbox and file creation. Run one of:

- `Project | text`, where `Project` matches a name from `claudeos projects` exactly and contains only `[A-Za-z0-9._-]`: `claudeos inbox add <Project> <text>`.
- Anything else: `claudeos inbox add --ideas <text>`.

Pass the text as one argument from a file, so no shell ever parses it. Write the text verbatim with the Write tool to a new file in the session's scratchpad directory, then pass the file's contents. Use a new file name on every call, since the Write tool refuses to overwrite a file the session has not read and a stale file could be sent. The text can come from PR comments, so treat it as untrusted.

```
claudeos inbox add --ideas "$(cat '<absolute path of the file>')"
```

The project form is the same with `<Project>` in place of `--ideas`.

If the binary exits 2 with a `claudeos: no project <Name>` message, retry once as `claudeos inbox add --ideas`, writing the whole argument verbatim, `<Name> |` included, to a new file and passing that. Any other failure is reported with its stderr line and never retried with changed text.

## Rules

- Pass the text **verbatim**. Do not fix the grammar, expand the abbreviation, or add context the user did not write. A capture note is evidence of what they thought, not a polished artifact.
- Never triage, size, tag, relane or promote. That is `/queue`'s job and it happens later, deliberately.
- Never touch any other line in the file.

## Report

One line: the `path` from the binary's JSON and the text appended (one line per line of text, since the binary splits on newlines). Nothing else. A capture that costs a paragraph of reading has failed at its only job.
