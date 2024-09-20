local lsp_zero = require "lsp-zero"

lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps { buffer = bufnr }
  local opts = { buffer = bufnr }

  vim.keymap.set({ "n", "x" }, "<leader>i", function()
    vim.lsp.buf.format {
      async = false,
      timeout_ms = 10000,
    }
  end, opts)
end)
