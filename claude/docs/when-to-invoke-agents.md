# When to Invoke Agents vs Follow Skills

## Quick Decision Tree

```
Is this a significant multi-step task?
├─ YES: Use progress-guardian to create PLAN/WIP/LEARNINGS
└─ NO: Follow skills directly

Discovered important insight?
├─ Architectural decision: Invoke adr agent
├─ Working knowledge/gotcha: Invoke learn agent
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
- **progress-guardian**: Manages PLAN/WIP/LEARNINGS
- **learn**: Documents insights to CLAUDE.md
- **adr**: Creates architecture decision records
- **docs-guardian**: Reviews/improves documentation

## When to Invoke Each Agent

### `progress-guardian`

**Invoke when:**
- Starting work spanning 3+ files
- Task takes >2 hours or multiple sessions
- Architectural decision involved
- Multiple steps with dependencies

**Don't invoke for:**
- Single-file bug fixes
- Documentation updates
- Obvious small changes

---

### `learn`

**Invoke when:**
- **Proactive**: Just discovered gotcha mid-work
- **Reactive**: Feature complete, insights to document
- "I wish I'd known this earlier" moment

**Don't invoke for:**
- Trivial discoveries already documented
- Obvious standard practices
- Personal notes not valuable to others

---

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
- `learn` when user says "I wish I'd known..."
- `adr` when user evaluates technology options

**Claude should wait for request:**
- `progress-guardian` (user decides workflow)
- `docs-guardian` (user decides quality bar)

## Parallel Invocation

Some agents work well in parallel:

```bash
# After feature complete
Invoke: learn + adr (if decision made) + docs-guardian (if docs changed)
```

## Significance Thresholds

### PLAN/WIP/LEARNINGS (progress-guardian)
**Use when:**
- 3+ files affected
- >2 hours estimated
- Multiple commits expected
- Architectural choice involved

**Skip for:**
- Single function
- Bug fix with known solution
- <30 minute changes

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

### CLAUDE.md Learning (learn agent)
**Use when:**
- Saves >30 minutes in future
- Prevents class of bugs
- Non-obvious behavior
- Architectural rationale

**Skip for:**
- Already documented
- Obvious/standard practice
- Unlikely to recur
