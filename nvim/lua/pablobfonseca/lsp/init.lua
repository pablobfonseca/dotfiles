local function on_attach(event)
  local b = event.buf
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = b, silent = true })
  end

  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gD", vim.lsp.buf.declaration)
  map("n", "K", vim.lsp.buf.hover)
  map({ "n", "i" }, "<M-K>", function()
    vim.lsp.buf.signature_help { max_width = 80 }
  end)
  map("n", "<leader>q", vim.diagnostic.setloclist)
  map("n", "<leader>d", vim.diagnostic.open_float)
  map("i", "<c-space>", function()
    vim.lsp.completion.get()
  end)
end

vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })

vim.lsp.enable {
  "ts_ls",
  "lua_ls",
  "bashls",
  "gopls",
  "tailwindcssls",
  "html",
  "pyright",
  "emmet-language-server",
  "harper-ls",
  "json-ls",
  "yaml-ls",
}
