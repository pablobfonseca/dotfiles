---
name: typescript-strict
description: Strict TypeScript patterns for safe, maintainable code. Use when writing or reviewing TypeScript, including .ts or .tsx files, schema validation, dependency injection, public API types, async control flow, and type-safety fixes.
---

# TypeScript Strict

Use this skill to keep TypeScript strict, explicit, and runtime-safe without weakening the type system.

## Core Rules

- Keep `strict` mode intact. Never weaken `tsconfig` to make errors disappear.
- Do not use `any`. Use `unknown` with narrowing when the type is genuinely unknown.
- Avoid `as` assertions. Use `satisfies`, discriminated unions, type guards, schemas, or better generic constraints.
- Avoid non-null assertions. Handle `null` and `undefined` explicitly.
- Prefer `type` for data shapes. Use `interface` for behavior contracts that implementations satisfy.
- Public functions and module boundaries should have explicit return types.
- Model domain state with discriminated unions and exhaustive switches.
- Use schema validation at runtime boundaries such as HTTP input, storage, config, and third-party data.

## Workflow

1. Inspect local TypeScript conventions before editing.
2. Identify the runtime boundary and source of truth for each type.
3. Reuse existing schemas, validators, branded IDs, and domain types.
4. Fix the type shape at the source instead of silencing downstream errors.
5. Run the repo's typecheck, lint, and focused tests when available.

## Detailed Reference

Read `references/claude-typescript-strict.md` when work involves schema organization, dependency injection, type-vs-interface decisions, or when the concise rules above are not enough.
