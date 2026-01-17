# Conciseness Clarification

## The Apparent Conflict

**CLAUDE.md says:**
> "Be extremely concise and sacrifice grammar for the sake of concision"

**Functional skill requires:**

```typescript
// Verbose but correct immutable update
const updated = {
  ...order,
  items: order.items.map((item, i) =>
    i === targetIndex ? { ...item, quantity: newQuantity } : item
  ),
};
```

These seem to conflict - how can we be "extremely concise" while writing verbose functional code?

---

## Resolution: Domain-Specific Conciseness

**Conciseness applies differently to different domains:**

| Domain              | Conciseness Rule                                   | Why                                   |
| ------------------- | -------------------------------------------------- | ------------------------------------- |
| **Communication**   | Extremely concise, sacrifice grammar               | Respect user's time                   |
| **Commit Messages** | Brief, skip articles/pronouns                      | Git history is for scanning           |
| **Code**            | Clear and correct first, brevity second            | Code is read far more than written    |
| **Documentation**   | Progressive disclosure, value-first, but thorough  | Users need complete information       |
| **Error Messages**  | Concise but actionable                             | User needs to know what to do         |
| **Comments**        | None (code should be self-documenting)             | Comments indicate unclear code        |
| **Function Names**  | Descriptive, not abbreviated                       | Clarity > character count             |
| **Variable Names**  | Clear intent, avoid single letters (except i, idx) | Future developers need to understand  |

---

## Communication Conciseness

**Be extremely concise in messages to the user:**

❌ **Too Verbose:**

```
I have thoroughly examined the code you provided and after careful
consideration, I believe that we should make some modifications to improve
the overall structure and maintainability of the implementation.
```

✅ **Concise:**

```
Reviewed code. Suggest these improvements:
- Extract validation logic
- Use factory pattern for test data
```

---

### Sacrifice Grammar

Skip articles, pronouns when meaning is clear:

❌ **Grammatically Correct but Verbose:**

```
I have identified three issues that need to be addressed:
1. The tests are not using the factory pattern
2. There is mutation of the array
3. The function is too long
```

✅ **Concise (Grammar Sacrificed):**

```
Three issues found:
- Tests need factory pattern
- Array mutation detected
- Function too long (split)
```

---

## Code Conciseness

**Code should be clear and correct first, brief second.**

### When Verbosity Is Correct

✅ **Verbose but clear functional code:**

```typescript
const updatedUsers = users.map((user) =>
  user.id === targetId ? { ...user, status: "active" } : user
);
```

Better than terse but unclear:

```typescript
// ❌ Too terse, unclear
const u2 = users.map((u) => (u.id === id ? { ...u, s: "active" } : u));
```

---

### When Brevity Improves Code

✅ **Concise and clear:**

```typescript
const active = users.filter((u) => u.isActive);
```

Better than unnecessarily verbose:

```typescript
// ❌ Unnecessarily verbose
const activeUsers = users.filter((user) => {
  return user.isActive === true;
});
```

---

### Function Names: Never Abbreviate

❌ **Too Concise:**

```typescript
const procPmt = (pmt: Pmt) => {...}  // What?
const calc = (items: Item[]) => {...}  // Calculate what?
```

✅ **Clear:**

```typescript
const processPayment = (payment: Payment) => {...}
const calculateOrderTotal = (items: Item[]) => {...}
```

**Rule:** Function names should be self-documenting, even if longer.

---

### Variable Names: Context Matters

**Short-lived loop variables:**

```typescript
// ✅ OK - loop variable, obvious from context
items.map((item, i) => ({ ...item, index: i }));

// ✅ OK - standard conventions
for (let i = 0; i < items.length; i++) {...}
```

**Longer-lived or non-obvious variables:**

```typescript
// ❌ Too terse
const t = calculateTotal(items);
const u = getUser(id);

// ✅ Clear
const total = calculateTotal(items);
const user = getUser(id);
```

---

## Commit Message Conciseness

**Commit messages should be brief and scannable:**

❌ **Too Verbose:**

```bash
git commit -m "I have added a new feature that allows the user to validate their email address by adding a new validation function that checks the format"
```

✅ **Concise:**

```bash
git commit -m "feat: add email validation"
```

**Details go in the commit body, not the subject:**

```bash
git commit -m "feat: add email validation

- Validates format using regex
- Rejects invalid domains
- 100% test coverage"
```

---

## Documentation Conciseness

**Documentation requires thoroughness, but use progressive disclosure:**

❌ **Wall of Text:**

```markdown
## Email Validation

This feature provides comprehensive email validation capabilities that allow you to validate email addresses according to RFC 5322 standards and also provides additional functionality for checking domain validity and...
```

✅ **Progressive Disclosure:**

```markdown
## Email Validation

**Purpose:** Validates email addresses per RFC 5322.

**Quick example:**

​```typescript
const valid = validateEmail("user@example.com"); // true
​```

**Details:** See [Email Validation Guide](./email-validation.md)
```

---

## Summary Table

| Context                | Conciseness Level | Grammar | Example                                     |
| ---------------------- | ----------------- | ------- | ------------------------------------------- |
| Messages to user       | Extreme           | Skip    | "Tests pass. Ready commit?"                 |
| Commit messages        | High              | Skip    | "feat: add validation"                      |
| Error messages         | Medium            | Keep    | "Invalid email: missing @ symbol"           |
| Code: function names   | Low               | Keep    | `processPayment`, not `procPmt`             |
| Code: logic            | Medium            | N/A     | Clear > brief, but avoid verbosity          |
| Code: functional       | Low               | N/A     | Spread operators, immutability > brevity    |
| Documentation: summary | High              | Keep    | "Validates emails per RFC 5322"             |
| Documentation: details | Low               | Keep    | Thorough examples and edge cases            |
| Comments in code       | None              | N/A     | Code should be self-documenting (no comments) |

---

## Decision Framework

When writing code, ask:

1. **Is this clear?**
   - YES → Good enough
   - NO → Make it clearer (even if longer)

2. **Could this be briefer WITHOUT losing clarity?**
   - YES → Make it briefer
   - NO → Keep as-is

3. **Am I abbreviating to save characters?**
   - YES → Stop. Use full names.
   - NO → Good

4. **Would future me understand this in 6 months?**
   - YES → Good
   - NO → Make it clearer

---

## Examples: Functional Code Verbosity Is OK

### ✅ Verbose but Correct

```typescript
const updatedCart = {
  ...cart,
  items: cart.items.map((item, i) =>
    i === index ? { ...item, quantity: item.quantity + 1 } : item
  ),
};
```

**Why this is good:**

- Immutable (critical requirement)
- Clear what's happening
- Correct functional pattern
- Verbosity serves purpose (safety)

---

### ❌ Terse but Wrong

```typescript
cart.items[index].quantity++; // Mutation!
```

**Why this is bad:**

- Violates immutability (critical violation)
- Shorter but incorrect
- Will cause bugs

---

## Functional Verbosity Patterns

These patterns are verbose but necessary:

### Immutable Array Updates

```typescript
// Verbose but correct
const updated = [...items.slice(0, index), newItem, ...items.slice(index + 1)];

// Terse but wrong
items[index] = newItem; // MUTATION
```

### Immutable Object Updates

```typescript
// Verbose but correct
const updated = { ...user, name: newName };

// Terse but wrong
user.name = newName; // MUTATION
```

### Nested Immutable Updates

```typescript
// Verbose but correct
const updated = {
  ...order,
  customer: {
    ...order.customer,
    address: {
      ...order.customer.address,
      zip: newZip,
    },
  },
};

// If this feels too verbose, use a library like immer
// But NEVER mutate directly
```

---

## When to Prioritize Brevity in Code

**Brevity is good when it doesn't sacrifice clarity:**

### Early Returns

```typescript
// ✅ Brief and clear
if (!user) return;
if (!user.isActive) return;
if (!user.hasPermission) return;

// ❌ Verbose with no benefit
if (user === null || user === undefined) {
  return;
}
if (user.isActive === false) {
  return;
}
```

### Ternaries for Simple Conditions

```typescript
// ✅ Brief and clear
const status = user.isActive ? "active" : "inactive";

// ❌ Unnecessarily verbose
let status: string;
if (user.isActive) {
  status = "active";
} else {
  status = "inactive";
}
```

### Array Methods

```typescript
// ✅ Brief and clear
const ids = users.map((u) => u.id);

// ❌ Verbose with no benefit
const ids = users.map((user) => {
  return user.id;
});
```

---

## Final Clarification

**"Sacrifice grammar for conciseness" applies to:**

- ✅ Messages to user
- ✅ Commit messages
- ✅ Quick notes/bullets

**Does NOT apply to:**

- ❌ Code (clarity first)
- ❌ Function/variable names (explicit, never abbreviated)
- ❌ Error messages (actionable, clear)
- ❌ Documentation (thorough, progressive)

**Functional programming verbosity is acceptable and encouraged** when it ensures immutability and correctness.
