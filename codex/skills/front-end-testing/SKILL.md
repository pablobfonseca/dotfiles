---
name: front-end-testing
description: Behavior-driven front-end testing with DOM Testing Library and user-event. Use when writing or reviewing UI tests for React, Vue, Svelte, browser DOM code, forms, accessibility behavior, async rendering, loading states, error states, or user interactions.
---

# Front-End Testing

Test behavior users can observe, not implementation details. Prefer accessible queries because they verify both behavior and semantic markup.

## Core Rules

- Query in Testing Library priority order: role, label text, placeholder only as fallback, text, display value, alt text, title, test id last.
- Use `userEvent.setup()` per test and await user interactions.
- Use `getBy*` for required elements, `queryBy*` for absence, and `findBy*` for async appearance.
- Avoid `container.querySelector`, class-name selectors, internal state assertions, and brittle snapshots.
- Test loading, empty, success, validation, and error paths for async UI.
- Assert accessible names for interactive controls.
- Keep tests resilient to refactors but strict about user-visible behavior.

## Workflow

1. Identify the user behavior or accessibility contract being tested.
2. Render through the same public API the application uses.
3. Interact with controls through `userEvent`.
4. Assert visible output, enabled or disabled state, focus, navigation, emitted events, or submitted data.
5. Prefer focused integration tests over implementation-heavy component tests.

## Detailed Reference

Read `references/claude-front-end-testing.md` for query examples, async patterns, mocking guidance, and common anti-patterns.
