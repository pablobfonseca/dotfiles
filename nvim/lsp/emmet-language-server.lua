---@type vim.lsp.Config
return {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = {
    "css",
    "html",
    "javascriptreact",
    "scss",
    "typescriptreact",
  },
  root_markers = { ".git" },
}
