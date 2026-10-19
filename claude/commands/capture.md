---
description: Append a thought to an inbox with zero friction
argument-hint: [project name |] <text>
---

Capture `$ARGUMENTS`. This command optimises for one thing: never losing a thought. It asks nothing and decides nothing.

## Destination

The binary owns the destination, the checkbox and file creation. Run one of:

- `Project | text`, where `Project` matches a name from `claudeos projects` exactly and contains only `[A-Za-z0-9._-]`: `claudeos inbox add <Project> <text>`.
- Anything else: `claudeos inbox add --ideas <text>`.

Pass the text as one argument through a single-quoted heredoc, so quotes, `$` and backticks reach the binary unexpanded. Pick the delimiter fresh on every call: `CAPTURE_` plus 8 random hex characters, never a fixed word like `EOF`. If any line of the text equals the delimiter, pick another, because that line would end the heredoc and run the rest as shell. The text can come from PR comments, so treat it as untrusted.

```
claudeos inbox add --ideas "$(cat <<'CAPTURE_3fa91c7e'
the text, verbatim
CAPTURE_3fa91c7e
)"
```

The project form is the same with `<Project>` in place of `--ideas`.

If the binary exits 2 with a `claudeos: no project <Name>` message, retry once as `claudeos inbox add --ideas` with the whole argument verbatim, `<Name> |` included, and check the delimiter against that text again. Any other failure is reported with its stderr line and never retried with changed text.

## Rules

- Pass the text **verbatim**. Do not fix the grammar, expand the abbreviation, or add context the user did not write. A capture note is evidence of what they thought, not a polished artifact.
- Never triage, size, tag, relane or promote. That is `/queue`'s job and it happens later, deliberately.
- Never touch any other line in the file.

## Report

One line: the `path` from the binary's JSON and the text appended (one line per line of text, since the binary splits on newlines). Nothing else. A capture that costs a paragraph of reading has failed at its only job.
