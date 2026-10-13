---
description: Interview a new project into its note, then queue the foundation items the user approves
argument-hint: <project name>
---

Set up project `$ARGUMENTS`: fill its note from a short interview, then offer foundation items for its queue. The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd. Read the vault's `CLAUDE.md` → Task queues first; its invariants bind you.

This command is the one exception to the vault rule that Claude may not invent queue items, and the exception is narrow: nothing outside the catalogue table below is ever proposed, and nothing is added without the user's answer.

## 1. Read

- `projects/$ARGUMENTS.md`: the note. Missing (or no argument given): list `projects/`, say to run `claudeos queue init <P>`, and stop.
- `claudeos queue dump $ARGUMENTS`: the queue as JSON. A failing dump: print its stderr, say to run `claudeos queue init $ARGUMENTS`, and stop.

Either stop writes nothing.

## 2. Interview

One question per message, open-ended prose, never AskUserQuestion. First ask what the project is about. Then at most three follow-ups, in this order:

1. Who it is for.
2. Platform and stack.
3. What a first version proves.

Skip a follow-up the earlier answers already cover. Nothing else is asked.

## 3. Write the note

Edit only these three sections of `projects/$ARGUMENTS.md`; the frontmatter and `## Notes` are never touched.

- `## Problem`: prose from the answers.
- `## Current state`: one bullet, `- YYYY-MM-DD: ...` with today's date, naming the stack and what exists.
- `## Next steps`: keep the `- See [[$ARGUMENTS/Queue|Queue]].` line and add one bullet naming the first item approved in section 5 with its link, `- First: <text> ([[$ARGUMENTS/Queue#^qN|qN]])`, or the first open queued line when none was approved, or no bullet when the queue is empty. Write it after section 5, since its bullet depends on the answer there.

A section that already has text (for Next steps, anything beyond the `See` line) is shown to the user first and rewritten only on an explicit yes; anything else leaves it as is.

## 4. Propose

The catalogue, text and size verbatim:

| Entry                                  | Size |
| -------------------------------------- | ---- |
| repo scaffold and a `make check` gate  | ~S   |
| CLAUDE.md and CONTEXT.md               | ~S   |
| data model                             | ~M   |
| auth                                   | ~M   |
| first vertical slice                   | ~M   |
| deploy                                 | ~S   |
| error tracking                         | ~S   |

An entry a queued line already covers (same deliverable, any wording) is skipped and named as covered by its `qN`. List the remaining entries as a numbered list in prose, in catalogue order, and ask the user to answer with numbers, `all` or `none`. Wait for the answer.

## 5. Add

Each approved entry, in catalogue order, is one call:

```
claudeos queue add $ARGUMENTS "<entry> #feat ~<size>" --lane "Needs spec"
```

The text is double-quoted, so escape its backticks (`` \` ``) or the shell runs `make check`. Each `add` prints `{"id": "qN"}`; that is the minted ID. A refused `add` is reported verbatim and the rest still run. `none`, or no answer, adds nothing. Then write `## Next steps` (section 3).

## 6. Report

One line per section written and one per `^qN` added, nothing else.
