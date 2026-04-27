---
name: neovim-lua
description: Neovim Lua configuration and plugin development guidance. Use when editing Neovim config, lazy.nvim plugin specs, Lua modules under nvim/, keymaps, autocmds, highlights, LSP setup, diagnostics, Treesitter integration, colorschemes, or Neovim plugin code.
---

# Neovim Lua

Use this skill for Neovim configuration and plugin work. Prefer idiomatic Lua, stable Neovim APIs, and the repo's existing lazy.nvim organization.

## Workflow

1. Inspect the current `nvim/` structure and relevant lazy.nvim specs before editing.
2. Read the matching reference before using unfamiliar Neovim APIs.
3. Prefer `vim.api`, `vim.keymap.set`, `vim.opt`, `vim.lsp`, and `vim.diagnostic` over stringly `vim.cmd` when direct APIs exist.
4. Use augroups for autocmds and avoid duplicate registrations.
5. Keep plugin specs lazy-loaded by appropriate `event`, `ft`, `cmd`, or `keys` triggers.
6. Cache work in hot paths such as statuslines, autocmds, and highlights.
7. Verify with the lightest available Neovim command or test path.

## References

- Read `references/nvim-api.md` for buffers, windows, namespaces, autocmds, keymaps, highlights, and common `vim.api` calls.
- Read `references/nvim-lsp.md` for `vim.lsp` setup, handlers, capabilities, and client behavior.
- Read `references/nvim-diagnostics.md` for `vim.diagnostic` signs, virtual text, float behavior, and config.
- Read `references/nvim-treesitter.md` for Treesitter parsers, nodes, queries, and syntax-aware work.
