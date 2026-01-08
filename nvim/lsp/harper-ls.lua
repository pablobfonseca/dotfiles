---@type vim.lsp.Config
return {
  cmd = { "harper-ls", "--stdio" },
  filetypes = {
    "gitcommit",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "python",
    "ruby",
    "swift",
    "toml",
    "typescript",
    "typescriptreact",
    "haskell",
    "dart",
    "sh",
  },
  root_markers = { ".git" },
}
