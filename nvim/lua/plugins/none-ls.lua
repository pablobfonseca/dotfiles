return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  config = function()
    local present, null_ls = pcall(require, "null-ls")

    if not present then
      return
    end
    local b = null_ls.builtins

    local sources = {
      -- webdev stuff
      b.formatting.prettierd.with {
        filetypes = {
          "html",
          "css",
          "markdown",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "yaml",
          "json",
          "jsonc",
          "scss",
        },
      }, -- so prettier works only on these filetypes

      -- Lua
      b.formatting.stylua,

      -- elm
      b.formatting.elm_format,

      -- ruby
      b.formatting.rubocop,
      b.diagnostics.rubocop,

      -- go
      b.formatting.gofmt,
      b.formatting.goimports,
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local on_attach = function(_, bufnr)
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end

    null_ls.setup {
      debug = true,
      sources = sources,
      on_attach = on_attach,
    }
  end,
}
