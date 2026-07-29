---
description: Review the inline comments on a PR and analyse whether each one makes sense before acting
argument-hint: "[pr-number] [--apply] [--watch]"
allowed-tools: Bash(gh:*), Bash(git:*), Read, Grep, Glob, Edit, Write
---

## Task

Review the **inline review comments** on a pull request and, for each one, decide whether the comment is valid. Analyse first — do NOT blindly apply suggestions.

Parse `$ARGUMENTS`:
- First non-flag token is the PR number (if empty, use the PR for the current branch).
- `--apply`: after analysis, automatically apply fixes for valid comments (see **Apply mode**).
- `--watch`: keep re-reviewing every 5 minutes until Copilot signals it is done (see **Watch mode**).

## Steps

1. **Resolve the PR.**
   - If `$ARGUMENTS` is given, use that PR number.
   - Otherwise: `gh pr view --json number,headRefName,title,url` to find the PR for the current branch. If none exists, stop and tell the user.

2. **Fetch inline comments** (the ones anchored to specific lines in the diff):
   - `gh api "repos/{owner}/{repo}/pulls/<number>/comments" --paginate` — returns review comments with `path`, `line`/`original_line`, `diff_hunk`, `body`, `user.login`, and `in_reply_to_id`.
   - Group replies (`in_reply_to_id`) under their parent so each thread is analysed as one conversation.
   - Skip nothing silently: if there are zero inline comments, say so and stop.

3. **Analyse each comment thread.** For every thread, read the actual code at `path` around the referenced line (use Read/Grep — don't rely only on the `diff_hunk`). Then judge:
   - **What is it asking for?** Restate the concern in one line.
   - **Is it correct?** Verify against the real code. Consider: is the claim factually true here, does the suggestion introduce bugs/regressions, does it fit the codebase conventions (check neighbouring code), is it in scope for this PR?
   - **Verdict:** `Agree` / `Partially agree` / `Disagree` / `Needs clarification` — with a concise reason.

4. **Report.** Output a per-comment breakdown, then a short summary. By default do NOT edit any files or push commits — recommend actions and wait for the user to decide what to apply. If `--apply` is set, continue to **Apply mode**.

## Output format

For each thread:

```
### <path>:<line> — @<author>
> <comment (trimmed)>

Concern: <one line>
Analysis: <your reasoning against the actual code>
Verdict: <Agree | Partially agree | Disagree | Needs clarification> — <why>
Suggested action: <what you'd do, or "none">
```

End with:

```
## Summary
- Agree: N   Partial: N   Disagree: N   Clarify: N
- Recommended next steps: <bullet list>
```

## Apply mode (`--apply`)

Only reachable after the full analysis in step 3. Apply fixes without asking for confirmation — the analysis verdict is the gate:

- **The reviewer is right.** Only threads whose verdict is `Agree` (or the agreed-on part of `Partially agree`) are eligible. Never apply a fix for a `Disagree` or `Needs clarification` thread — those are reported only.

For each eligible fix:
- Make the minimal edit that resolves the concern, matching surrounding code style. Do not expand scope beyond the comment.
- After all edits, show a diff summary. Commit only if the user asks (follow the repo's commit conventions); otherwise leave the changes staged for them to review.
- Reply to each addressed thread with a one-line note of what changed: `gh api repos/{owner}/{repo}/pulls/<number>/comments/<comment_id>/replies -f body='...'`.
- **Always resolve the conversation** after addressing it. Thread IDs come from GraphQL, not the REST comment ID — map each thread by its first comment's `databaseId`:
  - `gh api graphql -f query='query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){reviewThreads(first:100){nodes{id isResolved comments(first:1){nodes{databaseId}}}}}}}' -f owner=<owner> -f repo=<repo> -F pr=<number>`
  - `gh api graphql -f query='mutation($id:ID!){resolveReviewThread(input:{threadId:$id}){thread{isResolved}}}' -f id=<threadId>`

For each `Disagree` thread:
- Add a 👎 reaction to the comment: `gh api repos/{owner}/{repo}/pulls/comments/<comment_id>/reactions -f content='-1'`.
- Reply with the one-line reason from the analysis so the reviewer sees why it was declined. Leave the thread unresolved.

## Watch mode (`--watch`)

Keep the PR under review until Copilot has nothing left to say. Delegate the 5-minute interval to the `/loop` skill rather than sleeping in-band:

- Start the loop with the review command minus `--watch`, e.g. `/loop 5m /review-pr <number> --apply`. Each firing runs one full pass (steps 1–4, plus Apply mode if `--apply` is set).
- **Termination check** (run at the end of every pass): fetch Copilot's latest output and look for the phrase **`and generated no new comments`** (case-insensitive):
  - Reviews: `gh api "repos/{owner}/{repo}/pulls/<number>/reviews" --paginate`
  - Issue comments: `gh api "repos/{owner}/{repo}/issues/<number>/comments" --paginate`
  - Consider only entries authored by the Copilot bot (`user.login` containing `copilot`).
- If the phrase is present in Copilot's most recent output, **stop the loop** (end the `/loop` run) and report a final summary. Otherwise let `/loop` fire the next pass in 5 minutes.

Guardrails:
- Only act on comments not already handled in a previous pass (track comment IDs already analysed / applied).
- Stop the loop with a status if Copilot never signals done after a reasonable number of passes (e.g. 12 ≈ 1 hour), rather than looping indefinitely.

## Rules

- Analyse before agreeing. A reviewer can be wrong — say so, with evidence from the code.
- Read the real code, not just the diff hunk.
- Never edit files unless `--apply` is set. Default remains review-only. With `--apply`, only `Agree`/`Partially agree` fixes are applied — no confirmation prompt.
- Replies, 👎 reactions, and thread resolution are `--apply`-only side effects. In default mode, report only.
