local function on_attach(event)
  local b = event.buf
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = b, silent = true })
  end

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  -- if client and client:supports_method "textDocument/completion" then
  --   vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
  -- end

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

vim.lsp.enable { "ts_ls", "lua_ls", "bashls", "gopls", "tailwindcssls" }
