---
description: Reconcile a project's queue against plans, PRs and GitHub issues
argument-hint: <project name> [--repo owner/name]
---

Make `projects/$ARGUMENTS/Queue.md` true. The work is deterministic and lives in the `claudeos` binary; this command only runs it and relays the report.

1. Run `claudeos sync $ARGUMENTS` (pass `--repo owner/name` through if given). It pulls the queue, matches plan frontmatter (`queue_item:` → `^qN`), PRs (`closingIssuesReferences` against `(#N)`, a `Closes … ^qN` body line, the plan file named in the body, or a body naming exactly one `^qN`) and issues (`gh issue view`), and writes through `queue-tool`: plan → `→plan:` and Needs spec → Ready; open PR → wip and `→pr:`; merged PR → done, `→pr:`, Shipped; closed issue → Shipped, `not_planned` → dropped with the reason. Precedence is merged PR > closed issue > plan > queue line. When several PRs claim one item, the one matched by the stronger rule owns it and the rest are reported. It honours `reconcile_issues: false`.
2. Print its output verbatim. The `needs judgment` section — orphan plans, closed-unmerged PRs, branch or title lookalikes, disagreements between a line and its issue — is for the human. Do not act on any of it; do not run `queue-tool` yourself.
3. If the binary is missing (`command not found`), say so and stop; the rules are not to be re-derived by hand. If it exits non-zero with `sync stopped:` (a `queue-tool` refusal — offline, duplicate IDs, rebase conflict, dirty repo), report the message and stop; never resolve it yourself.

The vault's `projects/<P>/Queue.md` is a generated view; nothing here edits it. Do not commit anything.
