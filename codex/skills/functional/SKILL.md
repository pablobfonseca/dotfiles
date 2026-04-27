---
name: functional
description: Practical functional programming patterns for immutable data, pure transformations, composable logic, and readable business rules. Use when writing data transformations, reducers, state updates, collection processing, or side-effect-light application logic.
---

# Functional Patterns

Use practical functional style where it improves correctness, testability, and readability. Do not add heavy functional abstractions for their own sake.

## Core Rules

- Prefer immutable data. Return new values instead of mutating inputs.
- Keep pure functions pure. Push I/O, logging, time, randomness, and external calls to edges.
- Use declarative array methods for transformations when they stay readable.
- Use options objects for multi-argument functions, especially when optional parameters exist.
- Prefer composition and small named functions over inheritance or deeply nested control flow.
- Do not contort code into functional style when a simple loop is clearer, needs early exit, or is measurably faster.

## Workflow

1. Separate data transformation from side effects.
2. Name intermediate concepts when a chain becomes hard to scan.
3. Preserve original inputs unless mutation is local, intentional, and documented by context.
4. Keep the public API obvious at the call site.
5. Test transformations through inputs and outputs, not implementation details.

## Detailed Reference

Read `references/claude-functional.md` for examples of immutable updates, array method tradeoffs, options-object APIs, and refactoring comments into self-documenting code.
