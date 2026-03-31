# When to Invoke Agents vs Follow Skills

## Quick Decision Tree

```
Discovered important insight?
├─ Architectural decision: Invoke adr agent
└─ Documentation issue: Invoke docs-guardian

Writing/reviewing documentation?
└─ Invoke docs-guardian for assessment
```

## Agents vs Skills

### Skills = Knowledge I Follow
- **functional**: Immutability, pure functions
- **typescript-strict**: TypeScript strict mode patterns
- **front-end-testing**: DOM Testing Library patterns
- Superpowers plugin provides: TDD, planning, debugging, verification

### Agents = Autonomous Workers I Invoke
- **adr**: Creates architecture decision records
- **docs-guardian**: Reviews/improves documentation
- **security-reviewer**: Audits code for OWASP vulnerabilities and secrets
- **database-reviewer**: Reviews SQL, schema design, indexing, RLS

## When to Invoke Each Agent

### `adr`

**Invoke when:**
- Making technology/library selection
- Choosing architectural pattern
- Trade-offs being evaluated
- "Why did we...?" question with no answer

**Don't invoke for:**
- Code style conventions
- Already documented in CLAUDE.md
- Temporary/experimental decisions

---

### `docs-guardian`

**Invoke when:**
- Creating new documentation
- Reviewing existing docs for quality
- Documentation feels confusing

**Don't invoke for:**
- Minor typo fixes
- Adding single code example
- Quick README updates

## Auto-Invoke Guidelines

**Claude should auto-invoke:**
- `adr` when user evaluates technology options
- `security-reviewer` after writing auth, user input handling, API endpoints, or payment code
- `database-reviewer` after writing migrations or complex queries

**Claude should wait for request:**
- `docs-guardian` (user decides quality bar)

## Parallel Invocation

Some agents work well in parallel:

```bash
# After feature complete
Invoke: adr (if decision made) + docs-guardian (if docs changed)

# After backend feature with auth + DB
Invoke: security-reviewer + database-reviewer (in parallel)
```

## Significance Thresholds

### ADR (adr agent)
**Use when:**
- One-way door (expensive to reverse)
- Alternatives evaluated
- Affects future decisions
- Future devs will ask "why?"

**Skip for:**
- Temporary decisions
- Already in CLAUDE.md
- No alternatives considered
