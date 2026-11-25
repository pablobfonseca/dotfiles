---
name: typescript-strict
description: TypeScript strict mode patterns. Use when writing any TypeScript code.
---

# TypeScript Strict Mode

These rules apply to test code as well as production code. For dependency injection and seam placement, see the `codebase-design` skill.

## Types

- No explicit `any`. Use `unknown` when the type is truly unknown.
- `type` for data structures, `interface` for behavior contracts (`UserRepository`, `PaymentGateway`).
- `readonly` on every data property, `ReadonlyArray<T>` for arrays.
- No `@ts-ignore` without a comment saying why.

```typescript
type User = {
  readonly id: string;
  readonly email: string;
  readonly name: string;
  readonly active: boolean;
  readonly roles: ReadonlyArray<string>;
};

interface UserRepository { findById(id: string): Promise<User | undefined> }
```

## Expected errors

Return a `Result` for expected errors. Throw only for bugs.

```typescript
type Result<T, E = Error> =
  | { readonly success: true; readonly data: T }
  | { readonly success: false; readonly error: E };

const findUser = (users: ReadonlyArray<User>, id: string): Result<User> => {
  const user = users.find((u) => u.id === id);
  return user
    ? { success: true, data: user }
    : { success: false, error: new Error("User not found") };
};
```

## Schema-first at trust boundaries

Validate with a schema wherever data crosses from external to internal: API responses, user input, files, env. Define one schema per contract, import it everywhere, and derive the type with `z.infer`.

```typescript
export const CreateUserRequestSchema = z
  .object({ email: z.email(), id: z.uuid() })
  .readonly();

export type CreateUserRequest = z.infer<typeof CreateUserRequestSchema>;
```

No schema for internal-only types, `Result`, utility types (`Partial<T>`, `Pick<T>`), `interface` contracts, or component props that do not come from a URL or an API.

## Branded types

Brand primitives that must not be mixed up. Build the brand in one constructor that validates first.

```typescript
type UserId = string & { readonly __brand: "UserId" };

const toUserId = (value: string): Result<UserId> =>
  value.length === 0
    ? { success: false, error: new Error("UserId must not be empty") }
    : { success: true, data: value as UserId };
```

## Immutability

Return new values instead of mutating inputs. Prefer `map`, `filter` and `reduce` over loops that push into an outer array.

```typescript
const rename = (user: User, name: string): User => ({ ...user, name });
const activeEmails = users.filter((u) => u.active).map((u) => u.email);
```

## tsconfig

On top of the defaults, enable:

```json
{
  "compilerOptions": {
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noPropertyAccessFromIndexSignature": true,
    "allowUnusedLabels": false
  }
}
```
