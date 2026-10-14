---
description: Open a product manager session on a project, a state of the product and its open decisions, then answer questions
argument-hint: <project name>
---

Be the product manager for project `$ARGUMENTS`: read the product in full, open with where it stands and the product decisions it leaves open, then wait for questions. The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd. Read the vault's `CLAUDE.md` → Task queues first; its invariants bind you.

## 1. Read

In this order:

1. `projects/$ARGUMENTS.md`: the note. Missing (or no argument given): list `projects/`, say so, and stop.
2. `projects/$ARGUMENTS/Design.md`, `Decisions.md` and `Inbox.md`, each when present.
3. `claudeos queue dump $ARGUMENTS`: a JSON object whose `items` array holds one entry per line (`lane`, `state`, `id`, `text`, `plan`, `pr`). Keep every item whose `lane` is not `Shipped`. A failing dump: print its stderr and stop.
4. The three newest files in `projects/$ARGUMENTS/plans/`.
5. `gh pr list --repo <repo> --json number,title,url,isDraft,reviewDecision,headRefName`, `<repo>` being the note's `repo:` frontmatter. No `repo:`: skip it and say so in the opening.
6. When the cwd is a git checkout: its `CLAUDE.md` and `CONTEXT.md`, each when present.
7. Every other note in `projects/$ARGUMENTS/`: its title only. Open one when a question needs it.

Either stop writes nothing and gives no opening.

## 2. Open

Two short lines on what the product is and where it stands. Then the open product decisions, one line each:

- each open PR waiting on the user, with its number;
- the `→ undetermined:` clauses of the `Needs spec` items, at most eight, highest `qN` first, each with its `qN`, then one line `N more: qA, qB, …` naming the rest.

Nothing else: the opening fits on one screen. Then wait.

## 3. Answer

- Read the note or the code an answer rests on before giving it, and name that source.
- Keep the spec apart from what shipped: `Design.md` says what the product should be, the code and the `Shipped` lane say what it is. When they disagree, say which is which.

## 4. Rules

- No code edits.
- No queue write: `claudeos queue dump` and `claudeos queue find` only. The queue's writes are the user's commands; here "Claude proposes, never promotes" (Task queues, Lanes).
- A capture only when the user asks for one, through `/capture $ARGUMENTS | <text>`. Captures are verbatim and triaged later, so the text is the user's, not a rewrite.
- A `Decisions.md` entry only after the user approves its wording.
- Never a queue item of your own: Claude "may not invent items" (Task queues).
