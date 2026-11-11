# Blast radius with the LSP tool

Before changing a function, method, type or exported name, or judging a change to one, find who uses it with the `LSP` tool, then confirm with `rg`. `rg` matches text: it never misses a spelling, but it merges same-named symbols from different packages. The language server resolves the symbol, so it separates them, but it returns nothing at all for a file it has not indexed. Use both, in that order.

## When

- A plan, a diff or a review comment changes a signature, a return value or an exported name, or deletes a symbol.
- A review comment claims that nothing else calls something, or that a change breaks callers.

Not for string literals, config keys, file paths, prose or generated code. Those are `rg` only.

## Languages

A server is enabled for Go, TypeScript and JavaScript, Swift, Lua and Python. Any other file is `rg` only.

## Recipe

1. Load the tool when it is deferred: `ToolSearch` with `select:LSP`. An agent whose `tools:` lists `LSP` calls it directly.
2. Point at the symbol's name where it is defined. `filePath`, `line` and `character` are 1-based, and `character` is the column of the name's first letter, not of `func` or `function`.
3. Call `findReferences` for every use and `incomingCalls` for the calling functions by name. For an interface method, also call `goToImplementation`.
4. Run `rg -n '\b<name>\b'` over the repo and compare the two lists.

## Reading the result

- `server is starting`, or any error on the first call: call again once.
- `No references found` is also what an unindexed file returns. Never report zero uses from it alone: step 4 decides.
- Fewer LSP hits than `rg` hits: read the extra `rg` lines. The same name in another package, a comment or a string is expected. A real use the server missed means its answer is partial, so go by `rg`.
- More LSP hits than `rg` hits: an alias, an embedded method or a call through an interface. Keep them.

## Only files under the session's root

The server indexes the directory the session started in. A file in another checkout, a linked worktree or a scratch clone outside that root returns nothing, or only the references in the same file, with no error. Measured on 2026-11-11 on one Go function: 6 references from inside the root, 0 for a worktree file queried from the main checkout, 2 for a scratch clone. For such a file use `rg`, or run the query from a session started in that tree.
