---
description: Review the inline comments on a PR and analyse whether each one makes sense before acting
argument-hint: "[pr-number]"
allowed-tools: Bash(gh:*), Bash(git:*), Read, Grep, Glob
---

## Task

Review the **inline review comments** on a pull request and, for each one, decide whether the comment is valid. Analyse first — do NOT blindly apply suggestions.

Target PR: `$ARGUMENTS` (if empty, use the PR for the current branch).

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

4. **Report.** Output a per-comment breakdown, then a short summary. Do NOT edit any files or push commits. Recommend actions and wait for the user to decide what to apply.

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

## Rules

- Analyse before agreeing. A reviewer can be wrong — say so, with evidence from the code.
- Read the real code, not just the diff hunk.
- Never apply changes in this command; it is review-only.
