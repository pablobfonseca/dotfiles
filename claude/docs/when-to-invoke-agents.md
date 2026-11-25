# When to Invoke Agents vs Follow Skills

## Agents vs Skills

### Skills = Knowledge I Follow
- **typescript-strict**: TypeScript strict mode patterns
- **codebase-design**: deep-module design vocabulary
- **domain-modeling**: ubiquitous language, ADRs, CONTEXT.md
- **diagnosing-bugs** (manual invoke): repro-loop-first debugging
- **handoff** (manual invoke): compact session state for a fresh session
- Superpowers plugin provides: TDD, planning, debugging, verification

### Agents = Autonomous Workers I Invoke
- **security-reviewer**: Audits code for OWASP vulnerabilities and secrets
- **database-reviewer**: Reviews SQL, schema design, indexing, RLS
- **Explore**: Read-only search across many files, returns the conclusion
- **neovim-lua**: Neovim config, plugins, colorschemes, Lua
- **python-pro**: Python implementation

## Agent Routing Table

Pick by primary task type. When two match, prefer the more specific one.

| Task | Agent |
| --- | --- |
| Python implementation | python-pro |
| Neovim config, plugins, colorschemes, Lua | neovim-lua |
| Broad read-only code search | Explore |
| Security audit | security-reviewer |
| SQL, schema, indexes, migrations | database-reviewer |

## Auto-Invoke Guidelines

**Claude should auto-invoke:**
- `security-reviewer` after writing auth, user input handling, API endpoints, or payment code
- `database-reviewer` after writing migrations or complex queries

## Parallel Invocation

Some agents work well in parallel:

```bash
# After backend feature with auth + DB
Invoke: security-reviewer + database-reviewer (in parallel)
```
