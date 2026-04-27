# Global Codex Guidance

## Working Agreements

- Be concise in user-facing messages and commit messages. Skip filler; keep grammar only where it helps clarity.
- Code clarity and correctness beat brevity. Do not abbreviate names to save characters.
- Read the relevant code before proposing or making changes. Let existing patterns guide the implementation.
- Prefer root-cause fixes over workaround code. Do not patch around broken behavior from the wrong layer.
- Keep changes scoped. Avoid unrelated refactors, formatting churn, or metadata updates.
- Preserve user changes. Never revert work you did not make unless explicitly asked.

## Quality Bar

- Prioritize clean, secure code. Assume user-facing and network-facing code will be reviewed by strong engineers and security testers.
- Validate untrusted input at boundaries. Do not add theatrical security checks; every check should have a real threat model.
- Avoid duplicated knowledge. Reuse existing helpers, schemas, validators, and patterns before creating new ones.
- Use structured parsers and APIs instead of ad hoc string manipulation when available.
- Delete dead code only when the user has asked for cleanup or approved the deletion.
- Add comments rarely. Prefer clearer names, smaller functions, and better structure.

## Implementation Habits

- For broad repetitive edits, script the mechanical part, inspect the diff, and remove temporary scripts before finishing.
- If a requested file reveals the real bug lives elsewhere, fix the real source instead of compensating locally.
- If a copied implementation starts diverging heavily from its source, pause and call out the tradeoff.
- If something fails twice after it should work, offer targeted debug logs with a task-specific prefix. Remove them after confirmation.

## Plans And Clarifications

- Ask clarifying questions only when a reasonable assumption would be risky. Otherwise make the conservative assumption and state it.
- For large plans, use phases and include unresolved questions at the end.
- Never commit plans.

## Git And GitHub

- Use the GitHub plugin or `gh` for GitHub work.
- Do not commit unless explicitly asked to commit, publish, or open a PR.
- When committing is requested, use concise conventional-style subjects such as `fix: handle empty state`.

## Codex-Specific

- Use relevant skills when their descriptions match the task. Load detailed references only when needed.
- Use subagents only when the user explicitly asks for agents, delegation, or parallel work.
- Prefer built-in `explorer` for read-only codebase questions and `worker` for bounded implementation work unless a custom agent is a better match.
