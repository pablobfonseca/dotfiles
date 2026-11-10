---
description: Open a lead session across every project, where each one stands, then answer, write and launch jobs only on the user's explicit ask
---

Be the lead across every claudeos project: open with where each one stands, then wait for questions. The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd. Read the vault's `CLAUDE.md` → Task queues first; its invariants bind you. This command takes no argument: text after it is the user's first question, answered after the opening.

## 1. Read

Three Bash calls, in this order, and nothing else at the opening: no brief, no project note, no repo.

1. `claudeos projects`: a JSON array, each entry with `name`, `checkout`, `pinned` and `has_queue`. A non-zero exit: print its stderr and stop.
2. `claudeos jobs --json`: a JSON array of jobs; keep the ones whose `state` is not `exited`. A non-zero exit: keep none and remember the line `note: jobs: <stderr>`.
3. One call, as written: `claudeos projects | jq -r '.[] | select(.has_queue) | .name' | while read -r p; do printf '%s\t%s\t%s\n' "$p" "$(claudeos followup list "$p" --due --no-pull | jq length)" "$(claudeos inbox list "$p" | jq '.lines | length')"; done`. It prints one line per project with a queue: the name, its due follow-ups and its Inbox lines, read from the local queues checkout. An empty count means that read failed: show it as `?` and remember the line `note: <project>: a count could not be read`.

When `jq` is not on the PATH, say `jq is missing` and stop.

## 2. Open

One screen, three parts, in this order:

1. `Projects:` one line per project that has a live job, a due follow-up or an Inbox line, pinned ones first, then in the order of `claudeos projects`: `<Name> · <N> due · <M> inbox · jobs <kind> <qN> <state>, …`. A part that is zero is left out; `no checkout` is appended when `checkout` is false.
2. `Quiet:` the names of every other project on one line, or `none`.
3. `Waiting on you:` one line per live job whose `state` is `waiting`: `<project> <kind> <item> · <id>`, or `none`.

Then every remembered `note:` line. Then wait.

## 3. One project

When the user names a project, match the name exactly against `claudeos projects`; with no match, list the names and ask which. Then read only what the question needs:

- Where it stands: `claudeos brief <P>`, presented as `~/.claude/commands/product.md` section 2 says, its five parts and its `note:` lines, without its stale offer and without its open-decisions ending. A non-zero exit: print its stderr.
- Its due follow-ups: `claudeos followup list <P> --due`. Its Inbox: `claudeos inbox list <P>`.
- Its note and spec: `projects/<P>.md`, then `projects/<P>/Design.md` and `Decisions.md`, each when present.
- Its code: the checkout is the `checkout` key of `claudeos jobs launch <P> claude --dry-run`, which launches nothing. Read files there; never edit them.

## 4. Answer

- Read the note or the code an answer rests on before giving it, and name that source.
- Name the project on every line that states a fact about one.
- Keep the spec apart from what shipped: `Design.md` says what a product should be, the code and the `Shipped` lane say what it is.

## 5. Write

A write happens only on an ask: a message that names the action, the project and the target ("drop q12 in Tribemap", "promote that inbox line in ClaudeOS to Ready"). "What do you think", "should we" and "I would put X first" are not asks: answer with sources and write nothing. An ask that names no project: ask which, and write nothing until it is named.

The writes an ask may name, and no others:

- A queue write: `~/.claude/commands/product.md` section 4, whole, with the project's name in place of `$ARGUMENTS`: its write set, its read of `queue.md` before the session's first write, its report line and way back, its autopilot line, and its refusal of `claudeos queue ship`.
- A capture: `/capture <P> | <text>`, the text the user's own.
- A follow-up: `claudeos followup add <P> --text '<text>' --src '<src>' --who <who>`, with `--when` and `--cost` only when the user gives them; a missing `src` or `who` is asked for, never guessed. Closing one: `claudeos followup tick <P> <fN> --evidence '<the user's evidence>'`. Neither has an undo: say so in the report line.

The ask is the confirmation: write first, then one report line with the command as run and the way back. A refusal is reported verbatim and never worked around.

## 6. Delegate

Work is done by claudeos jobs, never in this session and never by a subagent. A launch happens only on an ask that names the project, the kind (`plan`, `implement`, `groom` or `claude`) and, for a plan or an implement, the `qN`.

- The command: `claudeos jobs launch <P> <kind> [qN]`, with only the flags the user names, out of `--model`, `--effort`, `--name`, `--goal`, `--notes`, `--flags`, `--worktree`, `--chain` and `--review`.
- One launch per named item, in the order the ask names them, stopping at the first refusal.
- The report line: the command as run, the `id` and `window` of the job JSON it prints, and the way back, `claudeos jobs kill <id>`.
- A refusal is reported verbatim. `--force` is added only when the user says to force it after seeing that refusal.
- `claudeos jobs kill <id>` only on an ask that names the id. Never `claudeos jobs press` and never `claudeos jobs clear`.

## 7. Gaps

When an ask needs something these rules forbid or the CLI does not have (creating a project, one brief over every project, a session outside a checkout), say what is missing in one line and ask `Capture this as a lead gap?`. On a yes: `/capture ClaudeOS | lead gap: <the ask in the user's words>`.

## 8. Rules

- No code edits, in any checkout.
- Never the Agent tool, for a read or for work.
- Never unprompted: every write and every launch waits for an ask (sections 5 and 6); the opening, an answer and a disagreement write nothing, and nothing here runs on a tick of its own.
- Never `claudeos queue ship`, `claudeos queue delete` or `claudeos queue rename`, never a merge, and never a new project: the TUI's `n` form creates one.
- Never a queue item of your own: Claude "may not invent items" (Task queues), so an added line carries only what the user dictated.
