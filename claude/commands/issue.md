---
description: File a queue item as a GitHub issue and write the number back
argument-hint: <project name> | <item text> [--repo owner/name]
---

File a queue item as a GitHub issue. Arguments: `$ARGUMENTS`.

## 1. Preflight — fail loudly, not silently

- `gh auth status`. If unauthenticated, say so and stop.
- Resolve the repo: `--repo` if given, else the `repo:` key in `projects/<project>.md` frontmatter, else ask. Never guess a repo.
- Find the queue line. **If it already carries a `(#N)`, stop and report the existing issue.** Issue refs are immutable and one line gets one issue, ever.
- Refuse items in `## Needs spec` or `## Someday`. An issue nobody can act on is noise; run `/spec` first.

## 2. Compose the body

- If the line has a `[[PLAN …]]` link, the plan is the body: goal, files, steps, edge cases, acceptance criteria, rendered as markdown with wikilinks converted to plain text (GitHub cannot resolve them).
- If it has no plan, the body is: the observable symptom or end state, what is known, what is not yet known, and a link line naming the vault note it came from. Keep it honest about being unspecced.
- Labels from the tags: `#bug`→`bug`, `#sec`→`security`, `#ops`→`infra`, `#feat`→`enhancement`. Only apply labels that already exist in the repo — check with `gh label list` and report any you dropped.

## 3. Create it

```
gh issue create --repo <repo> --title "<title>" --body-file <tmpfile> [--label ...]
```

Title is the queue line's text, trimmed of markers, sentence case, under 80 chars.

## 4. Write back

Append ` (#N)` to the queue line, before any `[[PLAN]]` link. If a plan note exists, add the issue URL under its Goal section.

## 5. Report

The issue URL, the labels applied and dropped, and the exact queue line as it now reads.

Do not commit unless asked.
