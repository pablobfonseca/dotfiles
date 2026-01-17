# When to Invoke Agents vs Follow Skills

## Quick Decision Tree

```
Is this a significant multi-step task?
├─ YES: Use progress-guardian to create PLAN/WIP/LEARNINGS
└─ NO: Follow skills directly

Am I about to write production code?
├─ YES, unsure about TDD: Invoke tdd-guardian (proactive)
└─ NO, already following TDD: Follow TDD skill

Tests just turned green?
├─ Complex refactoring needed: Invoke refactor-scan
└─ Simple/obvious refactoring: Follow refactoring skill

Discovered important insight?
├─ Architectural decision: Invoke adr agent
├─ Working knowledge/gotcha: Invoke learn agent
└─ Documentation issue: Invoke docs-guardian

Writing/reviewing documentation?
└─ Invoke docs-guardian for assessment
```

## Agents vs Skills

### Skills = Knowledge I Follow
- **tdd**: RED-GREEN-REFACTOR workflow
- **functional**: Immutability, pure functions
- **testing**: Factory patterns, behavior testing
- **planning**: Three-document model
- **refactoring**: When and how to refactor

### Agents = Autonomous Workers I Invoke
- **progress-guardian**: Manages PLAN/WIP/LEARNINGS
- **tdd-guardian**: Coaches TDD, verifies compliance
- **refactor-scan**: Assesses refactoring opportunities
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

### `tdd-guardian`

**Invoke when:**
- **Proactive**: About to implement feature, want TDD guidance
- **Reactive**: Code written, need compliance verification
- Unsure if TDD was followed correctly

**Don't invoke if:**
- Already naturally following TDD workflow
- Tests green, coverage 100%, obvious compliance

---

### `refactor-scan`

**Invoke when:**
- Tests just turned green (complex codebase)
- Unsure about abstraction decision
- Multiple refactoring opportunities visible

**Don't invoke if:**
- Code obviously clean
- Simple one-liner refactoring
- Following refactoring skill directly

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
- `refactor-scan` after every GREEN (if complex)
- `learn` when user says "I wish I'd known..."
- `adr` when user evaluates technology options

**Claude should wait for request:**
- `progress-guardian` (user decides workflow)
- `tdd-guardian` proactive (user decides coaching level)
- `docs-guardian` (user decides quality bar)

## Parallel Invocation

Some agents work well in parallel:

```bash
# After feature complete
Invoke: learn + adr (if decision made) + docs-guardian (if docs changed)

# After GREEN
Invoke: refactor-scan (blocking) → learn (if insights found)
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
