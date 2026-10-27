---
description: Groom a project's Queue.md and propose the next 5 by leverage
argument-hint: <project name>
---

Groom `projects/$ARGUMENTS/Queue.md`. The vault is `~/obsidian/SecondBrain`; every vault path in this command resolves there, whatever the cwd. Read the vault's `CLAUDE.md` → Task queues first; its invariants bind you. If the file does not exist, list `projects/` and stop.

## How to work (read before anything)

You are the judgment half of grooming; every mechanical step already ran. Rules that keep a weaker session from doing damage:

- **Never reword a line into something more abstract.** Append markers (`#tag`, `~size`, `→ question`) with `claudeos queue edit`; leave the user's words. A groomed line is *more* specific, never less.
- **When unsure, do less.** Unsure whether an Inbox line is work → leave it in the Inbox. Unsure of a size after the code read (section 3) → `~M`. Unsure whether two lines are one deliverable → leave both and say so in the report. Unsure whether an item shipped → leave it open and flag the evidence.
- **Cite or do not rank.** Every line of the `> proposed:` blockquote names the note, plan, PR or incident that justifies it. A rank you cannot cite goes at the bottom with "no note supports this".
- **One write per change, through `claudeos queue`.** `add`, `stamp`, `state`, `lane`, `mark` for single lines; `edit begin` / `edit commit -m` only for splits, merges, rewording markers and the blockquote. Never open the vault's Queue.md.
- **Report in the fixed shape of section 6**, nothing else appended.
- **Pass text arguments in single quotes, never double.** Bash expands backticks, `$` and `!` inside double quotes, so an Inbox line holding one stops matching byte for byte or runs a command. Nothing expands inside single quotes; a `'` in the text is written `'\''`, or the text goes in a scratchpad file passed as `"$(cat <file>)"`. `<raw>` is the decoded JSON string from `claudeos inbox list`, not its printed spelling: the list escapes `&` as `&` and `"` as `\"`.

Worked example, one Inbox line: `- [ ] the jobs pane shows waiting after I answered` → `claudeos inbox promote <P> '- [ ] the jobs pane shows waiting after I answered' 'The jobs pane keeps showing waiting after the prompt is answered #bug ~S' --lane Ready` (symptom kept verbatim, tag and size appended, Ready because a stranger could start, the raw line removed by the same command). A line like `think about telegram` stays in the Inbox: it names no symptom and no end state.

## 0. Reconcile natively, then read

Queue authority lives in the vault-queues repo; `claudeos queue` pulls before every read and pushes every write when the queues directory has an origin (a plain folder or a local checkout writes locally), and the vault's `projects/<P>/Queue.md` is a generated read-only view. If any `claudeos queue` call reports a rebase conflict, duplicate IDs or a dirty repo, stop and report; never resolve it yourself.

Grooming a stale queue ranks fiction, so first run `claudeos sync $ARGUMENTS` and print its output. It does the whole plans → PRs → issues reconciliation and writes what the artifacts prove; its `needs judgment` lines are input to your grooming below, not something to act on blindly. If it says the GitHub half was skipped, say so in your report. Do not re-derive any reconciliation by hand.

## 1. Read the whole picture before touching a line

- `projects/$ARGUMENTS.md` — goal, status, next steps. This is what "leverage" is measured against.
- `claudeos queue dump $ARGUMENTS` — the queue, parsed: every line's lane, state and markers as JSON, plus `duplicates`, `unstamped` and `next_id`. Trust this parse instead of reading the markers by eye; to change a line, use `claudeos queue` rather than opening the vault's read-only view.
- `projects/$ARGUMENTS/Inbox.md` if present — loose capture that may contain promotable items.
- Every support note in `projects/$ARGUMENTS/` whose title suggests a plan, audit or incident. You cannot rank without knowing what is already specced.
- `claudeos queue triage $ARGUMENTS` — the Judge's read of every open and Inbox line, as JSON: `tag` and `size` (an `option` with its `confidence`), and `claude`, `needs_spec`, `promotable` (Inbox lines only) and each `duplicates[].noul` as probabilities from 0 to 1. Read a Noul ≥ 0.7 as yes, ≤ 0.3 as no, anything between as unsure; a Choice whose `confidence` is under 0.5 is unsure; a `duplicates` entry ≥ 0.8 is the same work. Unsure falls to "when unsure, do less". A line with an `error`, or a triage that exits before printing (no key file), is judged by you alone; say which in the report.

## 2. Promote from Inbox

Anything in Inbox.md that names an observable symptom or a desired end state becomes a queue line. Read the triage's `promotable` first: at or above 0.7 the line is promoted, at or below 0.3 it stays, and a line between (the unsure band) is decided by you after a bounded read, never skipped. Read the evidence the line names: a `qN` in the dump you already read, a plan, audit or incident note in `projects/$ARGUMENTS/`, a PR or review by number (`gh pr view <n> --json title,body,state`), a job in `claudeos jobs --json`; then the code it names, under the **Size from the code** caps of section 3 (at most 3 symbols, 3 hits, `git grep` against `origin/HEAD`, nothing of it sent to the Judge). Promote when the read confirms what the line claims (the symptom is in the code as described, or the end state is concrete enough that a stranger could start) and leave it when it does not; either way the report lists the line with its score and the reason in one sentence (section 6). A duplicates entry ≥ 0.8 means it is already queued whatever its promotable: leave it in the Inbox and name the qN in the report. Prose, half-thoughts and reference material stay in Inbox.md, and its non-actionable content is left untouched.

A promoted line's lane is Needs spec when needs_spec is yes, Ready otherwise; its tag is the triage's when not unsure, and its size comes from the Size from the code rule in section 3. The text is the line's own words with the markers appended, never reworded (see How to work); a `^qN` inside it is written `qN`, because the add refuses text that carries one (the tool stamps the new ID itself). Promote with one command, `claudeos inbox promote $ARGUMENTS '<raw>' '<line text>' --lane <Lane>`, where `<raw>` is the line's decoded `raw` value from `claudeos inbox list $ARGUMENTS`, bullet included (promote matches the Inbox line verbatim): it adds the queue line, stamps the `^qN`, removes the raw line from Inbox.md and prints `{"id", "count"}`. Never `claudeos queue add` for an Inbox line and never edit Inbox.md yourself; the queue line is the record, with no "moved to Queue" annotation or breadcrumb left behind.

A promote that prints `added ^qN to <Lane>, but inbox line not removed` has landed the queue line: run `claudeos inbox remove $ARGUMENTS '<raw>'` once, and if that fails too, report the raw line and the qN instead of retrying the promote (a retry would add a second queue line).

A line whose text names a `qN` that sits in `## Shipped` as `- [x]` (written `q14`, `^q14` or `[[<P> Queue#^q14]]`; check the lane in the `claudeos queue dump` you already read, never a date) is rework unless a successor tell is present: append `#rework` beside its other tag before the `promote`, so `- [ ] the jobs pane still shows waiting since q93 shipped #bug #rework ~S`. A successor tell is the shipped `qN` written as `after qN`, `waits on qN`, `depends on qN`, `blocked by qN` (the four `queue.WaitsOn` parses), `successor of qN`, `qN successor` or `phase N of qN`, in any case, or the shipped item's plan listing this line under Related queue items as `successor`. Any tell present means not rework, whatever else the line names: the line builds on the shipped item rather than correcting it. An open, dropped or unknown `qN` does not count. This is the whole 72-hour-follow-up rule; `claudeos stats` counts the tag per week by the line's added date, so nothing detects it later.

## 2b. Repeated frictions (ClaudeOS only)

Skip this section unless `$ARGUMENTS` is `ClaudeOS`. The commands, hooks, guards and plan rules every project's sessions run under belong to that project (the dotfiles are its repo), so its groom reads every project's frictions and no other groom reads any.

1. Run `claudeos friction --since <date>`, with `<date>` the `proposed.date` of the `claudeos queue dump` you read in section 1, or `claudeos friction` alone when the dump has no `proposed`. It prints JSON: `frictions`, newest first, each with `at`, `project`, `item`, `kind`, `text`, `session` and `transcript` (the run's transcript on disk, empty when Claude Code no longer has it or the binary predates the key), and a `note` set only when the Judge classified nothing (say it in the report).
2. Cluster the rows: two or more records with the same `kind` that name the same subject (one command, hook, guard, plan rule, helper or check, however each is worded). A row whose `kind` is `unsure` or empty joins a cluster by subject alone. One record is not a cluster. Unsure whether two records name one subject → they do not.
3. Skip a cluster that an open or wip line in the dump already covers (it names the same file or rule for the same failure); name that line's qN in the report.
4. For each remaining cluster add one line: `claudeos queue add ClaudeOS '<the failure, in the words of the records>; change <the harness file path or plan rule to change> (from friction: <project> <item> for each record, the project alone when item is empty) #harness<tags>' --lane '<lane>'`. The cluster is ready-grade when at least 3 of its records have `kind` `missing_instruction` or `repeated_manual_step`, those records come from 2 or more distinct `item`s, and each of them has a non-empty `transcript`; then `<lane>` is `Ready` and `<tags>` is ` #claude`. Otherwise `<lane>` is `Needs spec` and `<tags>` is empty. A record whose `kind` is `unsure`, empty or any other kind neither counts toward the 3 nor disqualifies the cluster; a counted record with no `transcript` does, and a `claudeos friction` that prints no `transcript` key at all makes every cluster Needs spec. One line per cluster, never two clusters in one line. Section 3 sizes and tags it like any other line and keeps its `#harness` and its `#claude`; triage ran before these lines existed, so you size and tag them alone. The `qN`s after `from friction:` say where each record came from, not what is being reworked: section 3's `#rework` rule does not apply to them.

## 3. Groom each open line

In this order, and only these:

- **Stamp**: run `claudeos queue stamp $ARGUMENTS`; it mints and pushes IDs atomically (and refuses offline, because minting against a stale remote is the two-machine race). IDs are immutable — never renumber, never reuse, never strip.
- **Split** anything that is two deliverables. Note the split in your report; each half gets its own fresh `^qN`, the original ID stays on the half closest to the original wording.
- **Size** unsized lines, from the code (rule below), else from the triage's size when not unsure: `~XS` under an hour, `~S` a sitting, `~M` a day, `~L` needs decomposition.
- **Tag** with at most what applies, from the triage's tag when not unsure; #claude when claude is yes: `#bug` `#feat` `#sec` `#ops`, plus `#claude` only if an agent could finish it unattended with no product decision to make (the code read informs this call too), plus `#rework` when the text names a `qN` that is `- [x]` in `## Shipped` and no successor tell is present (the step 2 rule, applied to lines already in the queue); an open line that carries `#rework` and fails that test loses it (`claudeos queue mark $ARGUMENTS <qN> --untag rework`).
- **Relane**: vague (needs_spec yes) → `## Needs spec` with a `→` question naming what is undetermined; waiting on something → `## Blocked` with a `→` dependency; explicitly-not-now → `## Someday`.
- **Link** to any existing plan, audit or incident note that already covers the item.
- **Dedupe**: if two lines are the same work (a duplicates entry ≥ 0.8 on either line), merge them and keep every `(#N)` ref.

**Size from the code.** The triage sees the line's text only. For each line groom is about to size, or about to tag `#claude`, read the code before settling on a size. A line that already carries `~size` keeps it, whoever wrote it; the read then informs only the `#claude` call. Bounded so it stays one pass:

- Checkout: a line tagged with a key of the project's `repos:` in `~/.config/claudeos/config.yaml` reads that repo's path; any other line reads the project's `path`. Run `git fetch origin` once per checkout per groom, then `git grep` against `origin/HEAD` (covers `master` and `main`), never the working tree.
- Symbols: what the line names (backticked identifiers, file paths, `pkg.Func` style names). Grep at most 3 symbols and read at most 3 hits per line.
- Size from what the hits show (how many files and call sites the change touches, whether the symbol exists at all), using the scale above. The code-based size wins over the triage's, so it is not reported as a disagreement.
- No symbol, no hits or a fetch failure: use the triage's size as before and name the line in the report.
- Code, grep output and file contents never go to the Judge or into any `claudeos queue triage` call (third-party API).

A triage answer that disagrees with the line's current marker is reported as a disagreement, never silently applied over a marker the user wrote.

How to write: single-line changes use the atomic subcommands (`state`, `lane`, `mark`, `add`); anything free-form — splits, rewording, merges, the `> proposed:` blockquote — goes through `claudeos queue edit $ARGUMENTS begin`, editing the printed file, then `claudeos queue edit $ARGUMENTS commit -m '<what changed>'`.

Do not reword a line into something more abstract than the user wrote. Precision is the point; a groomed line should be *more* specific, never less.

## 4. Detect what is already done

For each open line, check the notes for evidence it shipped (a plan marked complete, an incident closed, an issue referenced as merged). If the evidence is solid, move it to `## Shipped` as `- [x]` and say why. If it is suggestive but not conclusive, leave it open and flag it in your report — do not guess a completion.

## 5. Propose the next 5

Replace the `> proposed:` blockquote under `## Next` with a fresh one, dated today. Five items, ranked, each with one or two sentences of *reasoning that cites a note* — not a restatement of the item. Write each rank as `> N. `^qNN` [[<P> Queue#^qNN]] — <reason, naming the note>`; `claudeos queue dump` parses the bare `` `^qNN` `` right after the rank number (the wikilink alone does not parse), and the wikilink keeps Obsidian navigation.

Then run `claudeos queue parallel $ARGUMENTS <the five ids, in rank order>` and append its `line` value verbatim as the blockquote's last line (`> parallel: …`): ` · ` separates tracks that run side by side, ` → ` says an item runs after the one before it (they share a named file, or one names the other), and `unknown:` lists items whose line and plan name no file, which is a reason to name one in the line, not a licence to call them independent. The command reads the local checkout and writes nothing; when it exits non-zero, append nothing and name the refusal in the report. Never edit the line by hand: a track you disagree with is a file the item's line should name.

Rank by leverage, roughly in this order of precedence:

1. Corrupts or loses data at the input (everything downstream inherits it)
2. Unblocks the project's stated critical path
3. Wrong output on the product's core promise
4. Already specced and user-facing (cheap real wins)
5. Written-up pain that has never been converted into work

Never move an item into `## Next` yourself. The blockquote is the whole deliverable.

## 6. Report

- What you promoted, split, resized, relaned, merged, or moved to Shipped — as a short list of before → after.
- **Left in the Inbox**, one line each, every `## Raw` line still there: its first six words, its `promotable` score (`no score` when the triage gave an `error` or did not run), and the reason it stays in one sentence: at or under 0.3; unsure and what the read found; a duplicate of `qN`; prose or reference material; a promote that failed, with the raw line and the qN when the add landed. An empty Inbox is one line, `Inbox: empty`, so a skipped list can be told from an empty one.
- The `> parallel:` line as written, or the refusal when none was appended.
- Lines `sized from code`, each with the triage's size beside it; lines where the code read gave nothing (no symbol, no hits, fetch failure) and fell back to the triage.
- Anything you deliberately left alone and why.
- Frictions (ClaudeOS only): the window (the `--since` date, or `all`), each cluster added as `qN ← <project> <item>, …` with its lane, each cluster skipped with the qN that covers it, the number of single records left alone, and the `note` when set.
- Which lines are now the largest unknowns in the queue.

Every `claudeos queue` mutation commits and, with an origin, pushes the authority itself and regenerates the vault view; there is nothing to commit in the vault for queue changes. Inbox.md edits still live in the vault as before.
