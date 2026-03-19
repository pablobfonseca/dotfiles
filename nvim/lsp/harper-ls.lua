---@type vim.lsp.Config
return {
  cmd = { "harper-ls", "--stdio" },
  filetypes = {
    "gitcommit",
    "markdown",
  },
  root_markers = { ".git" },
}
