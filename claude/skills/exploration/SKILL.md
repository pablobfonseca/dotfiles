---
name: exploration
description: Debugging, prototyping, and learning mode. Use when investigating bugs, exploring APIs, or spiking solutions before committing to TDD implementation.
---

# Exploration Mode

When you don't yet know the solution, exploration mode relaxes strict TDD requirements to enable learning and investigation.

**Core Principle:** Explore freely, capture learnings, then implement properly with TDD.

---

## When to Use Exploration Mode

Use exploration mode when ANY of these are true:

1. **Debugging Unknown Issues**
   - "Something's broken but I don't know why"
   - Need to add logging/debugging code to investigate
   - Root cause unclear

2. **Learning New APIs/Libraries**
   - Exploring unfamiliar library
   - Understanding third-party behavior
   - Testing integration points

3. **Spiking Solutions**
   - Multiple approaches possible, unclear which is best
   - Need proof of concept before committing
   - Architectural exploration

4. **Investigating Edge Cases**
   - Unclear how system behaves in scenario
   - Need to experiment to understand
   - Testing assumptions

5. **Performance Investigation**
   - Profiling to find bottlenecks
   - Testing different optimizations
   - Measuring before optimizing

---

## Exploration Workflow

### Phase 1: EXPLORE (No TDD Required)

**Objective:** Gather information and understanding.

**What you can do:**

- ✅ Add console.logs / debug statements
- ✅ Write throwaway experimental code
- ✅ Comment out code to isolate issues
- ✅ Try multiple approaches
- ✅ Use REPL / interactive debugging
- ✅ Write temporary test scripts
- ✅ Add TODO comments
- ✅ Skip tests entirely during exploration

**Rules:**

1. **Branch or stash** - Don't commit exploration code to main branch
2. **Mark as temporary** - Prefix commits with `spike:` or `debug:`
3. **Capture learnings** - Document discoveries as you go

**Example exploration commit:**

```bash
git commit -m "spike: testing three approaches to data caching"
```

---

### Phase 2: CAPTURE (Document Learnings)

**Objective:** Preserve insights before deleting exploration code.

**Create exploration log:**

```markdown
# Exploration Log: [Problem]

**Date**: 2026-01-17

**Objective**: [What you were investigating]

## Approaches Tried

### Approach 1: [Name]

- **Tried**: [What you did]
- **Result**: [What happened]
- **Why it failed/succeeded**: [Analysis]

### Approach 2: [Name]

- **Tried**: [What you did]
- **Result**: [What happened]
- **Why it failed/succeeded**: [Analysis]

## Key Discoveries

1. [Important insight 1]
2. [Important insight 2]
3. [Important insight 3]

## Gotchas Found

- [Unexpected behavior]
- [Edge case discovered]
- [API quirk]

## Recommended Approach

**Decision**: [Which approach to use]

**Rationale**: [Why this one]

**Implementation Plan**:

1. [Step 1 with TDD]
2. [Step 2 with TDD]
3. [Step 3 with TDD]

## References

- [Link to docs]
- [Stack Overflow answer]
- [Code example that helped]
```

**Save to:** `exploration-logs/YYYY-MM-DD-problem-name.md`

---

### Phase 3: CLEAN SLATE

**Objective:** Remove all exploration code.

**Process:**

1. **Save the log** - Move to `exploration-logs/`
2. **Delete exploration code** - Completely remove or stash
3. **Return to known-good state** - `git reset --hard` or delete branch
4. **Start fresh** - Begin TDD implementation with learnings

**Example:**

```bash
# Save exploration log
mv exploration-cache-approaches.md exploration-logs/2026-01-17-cache-approaches.md

# Delete spike branch (or reset to main)
git checkout main
git branch -D spike/cache-approaches

# Ready for TDD implementation
```

---

### Phase 4: IMPLEMENT (Return to TDD)

**Objective:** Build the solution properly with TDD.

**Now you know:**

- Which approach works
- What edge cases exist
- What gotchas to avoid
- How the API behaves

**TDD process:**

1. **Write failing test** based on exploration learnings
2. **Implement minimal code** using the approach you discovered
3. **Refactor** with confidence (you already explored the space)

**Reference the exploration log** in commits:

```bash
git commit -m "feat: implement caching (see exploration-logs/2026-01-17-cache-approaches.md)"
```

---

## Debugging Workflow

Special case: debugging production issues.

### 1. Reproduce the Bug

Create minimal reproduction:

```typescript
// bug-reproduction.ts (temporary file)
// TODO: Delete after fix

const reproduce = () => {
  // Minimal code that triggers the bug
};

reproduce(); // Should fail/error
```

**No test needed yet** - you're just confirming the bug exists.

---

### 2. Isolate the Cause

Add logging, breakpoints, or temporary code:

```typescript
console.log("DEBUG: value at step 1:", value);
console.log("DEBUG: value at step 2:", value);
console.log("DEBUG: value at step 3:", value);
```

**Mark clearly as temporary:**

```typescript
// DEBUG - REMOVE BEFORE COMMIT
console.log("value:", value);
// END DEBUG
```

---

### 3. Understand the Root Cause

Document findings:

```markdown
## Bug Investigation: [Bug Name]

**Symptom**: [What the user sees]

**Root Cause**: [What's actually wrong]

**Why it happens**: [Explanation]

**Example**: [Specific scenario that triggers it]
```

---

### 4. Write Failing Test (Return to TDD)

Now that you understand the bug, write a proper test:

```typescript
it("should handle edge case X", () => {
  const input = getMockInput({ edgeCase: true });
  const result = process(input);
  expect(result.success).toBe(true); // Currently fails
});
```

---

### 5. Fix with TDD

1. **RED**: Test fails (reproduces bug)
2. **GREEN**: Fix the bug (minimal change)
3. **REFACTOR**: Clean up if needed

---

### 6. Clean Up Debugging Code

**Remove ALL debug code:**

```bash
# Search for debug statements
grep -r "console.log" src/
grep -r "DEBUG" src/
grep -r "TODO.*DELETE" src/

# Remove before commit
```

**Delete reproduction files:**

```bash
rm bug-reproduction.ts
```

**Commit only the fix:**

```bash
git add test/bug-fix.test.ts src/actual-fix.ts
git commit -m "fix: handle edge case X correctly"
```

---

## Exploration Mode Anti-Patterns

### ❌ Committing Exploration Code

```bash
# WRONG
git commit -m "feat: add caching"
# But code is messy, has debug logs, multiple approaches tried
```

**Fix**: Clean slate → TDD implementation → commit clean code.

---

### ❌ Keeping Debug Code in Production

```typescript
// WRONG - Left in production
console.log("DEBUG: processing payment", payment);
if (process.env.DEBUG) {
  // Debug-only code path
}
```

**Fix**: Remove ALL debug code. If needed permanently, add proper logging.

---

### ❌ Not Documenting Learnings

```bash
# Deletes spike branch without capturing insights
git branch -D spike/experiment
# Lost: What worked, what didn't, why
```

**Fix**: Always create exploration log before deleting.

---

### ❌ Exploration Becoming Implementation

```typescript
// WRONG - Spike code becomes production code
// (Never wrote proper tests, just kept the spike)
```

**Fix**: Exploration must always transition to proper TDD implementation.

---

## Exploration Log Template

Save exploration logs to `exploration-logs/` in repository:

```markdown
# Exploration: [Problem Name]

**Date**: YYYY-MM-DD

**Explorer**: [Your name]

**Objective**: [What you were trying to figure out]

## Context

[Why this exploration was needed]

## Hypotheses

1. [What you thought might work]
2. [Alternative theory]

## Experiments

### Experiment 1: [Name]

**Hypothesis**: [What you expected]

**Method**: [What you tried]

**Code**: (optional snippet or link to spike branch)

**Result**: [What actually happened]

**Learning**: [What this taught you]

---

### Experiment 2: [Name]

[Same structure]

## Key Discoveries

1. **[Discovery 1]**: [Explanation and impact]
2. **[Discovery 2]**: [Explanation and impact]

## Gotchas & Edge Cases

- [Unexpected behavior found]
- [API quirk discovered]

## Recommended Solution

**Approach**: [Which method to use]

**Why**: [Rationale based on experiments]

**Trade-offs**: [What we gain/lose]

## Implementation Plan

1. [TDD step 1]
2. [TDD step 2]
3. [TDD step 3]

## References

- [Docs that helped]
- [Articles read]
- [Similar code in codebase]

## Cleanup Checklist

- [ ] Exploration log saved
- [ ] Spike branch deleted (or stashed)
- [ ] Debug code removed
- [ ] Temporary files deleted
- [ ] Ready to start TDD implementation
```

---

## Integration with TDD

**Exploration is not a replacement for TDD - it's preparation.**

```
Normal TDD:
  Write test → Implement → Refactor

TDD with Exploration:
  Explore → Learn → [Clean Slate] → Write test → Implement → Refactor

Debugging:
  Investigate → Find cause → [Clean Slate] → Write test → Fix → Refactor
```

---

## When to Exit Exploration Mode

Exit exploration and return to TDD when:

- ✅ You understand the problem
- ✅ You know which approach works
- ✅ You've documented learnings
- ✅ You're ready to write a failing test

**Don't stay in exploration mode longer than necessary.**

---

## Exploration Checklist

Before entering exploration mode:

- [ ] I've tried normal TDD and need to learn more
- [ ] I'll document my findings
- [ ] I'll delete all exploration code afterward
- [ ] I'll implement properly with TDD after learning

After exploration:

- [ ] Learnings documented in exploration log
- [ ] All debug/spike code removed
- [ ] Ready to write failing test
- [ ] Know which approach to implement

---

## Summary

**Exploration mode allows you to:**

- Debug without tests
- Experiment freely
- Learn new APIs
- Spike solutions

**But you must:**

- Document learnings
- Delete exploration code
- Return to TDD for implementation
- Never commit exploration code

**Remember:** Exploration is a tool for learning, not a shortcut around TDD.
