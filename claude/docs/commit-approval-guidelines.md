# Commit Approval Guidelines

## The Rule

**From planning skill:** "NEVER commit without user approval."

## Why This Exists

- User maintains control of git history
- Opportunity to review before commit
- Prevents accidental commits of incomplete work
- Creates natural checkpoint for discussion

## When to Wait for Approval

### Always Wait (High Stakes)

1. **Refactoring commits**
   - External APIs might be affected
   - User should verify behavior unchanged

2. **Multi-file changes**
   - Scope is significant
   - User wants to review impact

3. **First commit of new feature**
   - User wants to verify approach
   - Sets pattern for rest of feature

4. **Plan deviations**
   - Changed from original PLAN.md
   - User needs to know why

5. **Uncertain changes**
   - You're not 100% confident
   - Better safe than sorry

### Consider Auto-Commit (Low Stakes)

These are candidates for auto-commit if user prefers faster flow:

1. **Obvious bug fixes**
   - Test added → bug fixed → all tests pass
   - Clear, isolated change

2. **Documentation updates**
   - Typo fixes
   - Adding examples
   - Updating comments

3. **Trivial refactorings**
   - Extracting single constant
   - Renaming variable for clarity
   - Adding types

4. **Continuing established pattern**
   - Step 5 of 10 in PLAN.md
   - Same pattern as previous commits
   - User already approved approach

## Proposed Workflow Options

### Option A: Always Ask (Current Default)

**Pros:**
- Maximum control
- Never surprised
- Can review every change

**Cons:**
- Interrupts flow state
- Slower iteration
- Can feel tedious for trivial commits

**Best for:**
- Learning phase
- High-stakes projects
- Preference for control

---

### Option B: Auto-Commit with Notification

**Process:**
```
1. Tests green
2. Assess change significance
3. If low-stakes → Auto-commit + notify user
4. If high-stakes → Wait for approval
```

**Example notification:**
```
✅ Auto-committed: "feat: add email validation"
   - 1 file changed, 23 insertions
   - All tests passing (42/42)

   git log -1 for details
   git reset HEAD~1 to undo
```

**Pros:**
- Faster iteration on straightforward work
- User can undo if needed
- Maintains flow state

**Cons:**
- Less control
- Requires trust in assessment
- Might commit something user wanted to review

**Best for:**
- Experienced users
- Fast iteration needed
- Trust in Claude's judgment

---

### Option C: Ask Once Per Session

**Process:**
```
User at session start:
"Auto-commit trivial changes today, ask for significant ones"

Then:
- Bug fixes, docs, simple refactors → Auto-commit
- Multi-file, API changes, first feature commit → Ask
```

**Pros:**
- Flexible per session
- User declares intent upfront
- Best of both worlds

**Cons:**
- Need to clarify intent each session
- "Trivial" subjective

**Best for:**
- Users who want flexibility
- Different projects have different needs

---

## Recommendation

**Default to Option A (always ask) UNLESS user specifies:**

```markdown
"Auto-commit low-stakes changes going forward"
→ Use Option B

"I'll tell you when I want fast mode"
→ Use Option C with user declaration each session
```

## Low-Stakes Criteria (for Auto-Commit)

Only auto-commit if ALL are true:

- [ ] Single file OR multiple files with isolated changes
- [ ] All tests passing
- [ ] No external API changes
- [ ] No refactoring of public interfaces
- [ ] Following established pattern
- [ ] No architectural decisions
- [ ] Change is reversible with `git reset HEAD~1`
- [ ] Confidence level: 100%

If ANY are false → Wait for approval.

## Communication Patterns

### Current Pattern (Always Ask)
```
"Step 3 complete. All tests passing.

Ready to commit: 'feat: add email validation'

Do you approve this commit?"
```

### Auto-Commit Pattern (Option B)
```
✅ Committed: 'feat: add email validation'
   All tests passing (42/42)
   src/validation/email.ts | 23 +++++++

   To review: git show HEAD
   To undo: git reset HEAD~1

Moving to Step 4: Handle edge cases
```

### High-Stakes (Always Ask Even in Option B)
```
⚠️ Significant change - requesting approval:

Changes:
- Refactored public API
- 3 files modified
- Tests updated to match

Ready to commit: 'refactor: extract validation logic'

Do you approve this commit?
```

## User Configuration

Add to ~/.claude/CLAUDE.md to set preference:

```markdown
## Commit Approval

**Preference**: [Always Ask | Auto-Commit Low-Stakes | Session-Based]

**Auto-commit criteria** (if using Auto-Commit mode):
- Single-file bug fixes: Yes
- Documentation updates: Yes
- Multi-file refactors: No (always ask)
- First commit of feature: No (always ask)
```

## Escape Hatch

User can always interrupt:

```
User: "Stop auto-committing, I want to review everything now"
→ Claude switches to Option A for rest of session
```
