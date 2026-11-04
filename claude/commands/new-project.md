---
description: Interview a new project into its note, then queue the first items the user approves
argument-hint: <project name>
---

Set up project `$ARGUMENTS`: fill its note from a short interview, or from a document the user points at, then offer first items for its queue. The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd. Read the vault's `CLAUDE.md` → Task queues first; its invariants bind you.

This command is the one exception to the vault rule that Claude may not invent queue items, and the exception is narrow: an item comes from an interview answer, from the catalogue below or from a passage of a document the user named, never from your own guess, and nothing is added without the user's answer.

## 1. Read

- No argument: list `projects/` and stop.
- `projects/$ARGUMENTS.md`: the note. Missing: ask, in one line, whether to create the project with `claudeos queue init $ARGUMENTS` (`--github owner/slug` when the user names a repo). On a yes run it, print its stdout and read again; on a no, or a failing init (print its stderr), stop.
- `claudeos queue dump $ARGUMENTS`: the queue as JSON. A failing dump on a project whose note exists: print its stderr, say to run `claudeos queue init $ARGUMENTS`, and stop.

Either stop writes nothing.

## 2. Interview

One question per message, open-ended prose, never AskUserQuestion. First ask what the project is about. Then at most three follow-ups, in this order:

1. Who it is for.
2. Platform and stack.
3. What a first version proves.

Skip a follow-up the earlier answers already cover. Nothing else is asked.

A document instead of answers: when the user points at one (a path, a vault note, a URL) at any point, read it in full; it answers every question it covers, and only the questions it leaves open are asked. It is also the source for section 4.

## 3. Write the note

Edit only these three sections of `projects/$ARGUMENTS.md`; the frontmatter and `## Notes` are never touched.

- `## Problem`: prose from the answers or the document.
- `## Current state`: one bullet, `- YYYY-MM-DD: ...` with today's date, naming the stack and what exists.
- `## Next steps`: keep the `- See [[$ARGUMENTS/Queue|Queue]].` line and add one bullet naming the first item approved in section 5 with its link, `- First: <text> ([[$ARGUMENTS/Queue#^qN|qN]])`, or the first open queued line when none was approved, or no bullet when the queue is empty. Write it after section 5, since its bullet depends on the answer there.

A section that already has text (for Next steps, anything beyond the `See` line) is shown to the user first and rewritten only on an explicit yes; anything else leaves it as is.

## 4. Propose

Three sources, and the user sees one numbered list.

**From the answers**, when the interview ran: every deliverable the user named in an answer, the answer to what a first version proves above all. A deliverable is something the user said the project will do, have or port; one item each, written as an end state in the vault's grammar (`<end state> #<tag> ~<size>`, `#feat` unless the answer states otherwise, size per the vault `CLAUDE.md`), e.g. `Queue and inbox screens ported from Devdeck into the standalone app, with the planned tweaks #feat ~M` or `Configurable notifications received in the app #feat ~M`, each traced to the answer phrase it comes from, quoted. Nothing the answers do not state is drafted. A question a document answered yields no answer items; the document items cover it.

**From the document**, when one was read: every deliverable the document states, one item each, written as a queue line in the vault's grammar (`<end state> #<tag> ~<size>`, tag and size per the vault `CLAUDE.md`), each traced to the passage it comes from. The document's own order and wording lead; nothing the document does not state is drafted. A document that reads as a plan (phases, milestones, a numbered list) gives one item per step.

**From the catalogue**, always, text and size verbatim:

| Entry                                  | Size |
| -------------------------------------- | ---- |
| repo scaffold and a `make check` gate  | ~S   |
| CLAUDE.md and CONTEXT.md               | ~S   |
| data model                             | ~M   |
| auth                                   | ~M   |
| first vertical slice                   | ~M   |
| deploy                                 | ~S   |
| error tracking                         | ~S   |

An entry a queued line, an answer item or a document item already covers (same deliverable, any wording) is skipped and named as covered by its `qN` or its number. An answer item covers an entry only when it names that same foundation piece (sign in with Google covers auth); a product feature, however central, never covers the first vertical slice, so porting existing screens and the first vertical slice both stay. A deliverable both an answer and the document state is listed once, as the answer item, with the document's passage named beside the phrase. List the answer items first in interview order, then the document items in document order, then the remaining catalogue entries in catalogue order, as one numbered list in prose, each line as it will be added, an answer item followed by its quoted phrase, and ask the user to answer with numbers, `all` or `none`; the user may also reword or resize an item in the answer, and the reworded line is what is added. Wait for the answer.

## 5. Add

Each approved item, in list order, is one call:

```
claudeos queue add $ARGUMENTS "<text> #<tag> ~<size>" --lane "Needs spec"
```

The text is double-quoted, so escape its backticks (`` \` ``) or the shell runs `make check`. Each `add` prints `{"id": "qN"}`; that is the minted ID. A refused `add` is reported verbatim and the rest still run. `none`, or no answer, adds nothing. Then write `## Next steps` (section 3).

## 6. Report

One line per section written and one per `^qN` added, nothing else.
