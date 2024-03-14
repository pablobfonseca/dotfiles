return {
  "nvimtools/none-ls.nvim",
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

      -- ruby
      b.formatting.rubocop,

      -- elm
      b.formatting.elm_format,

      -- python
      b.formatting.black,

      -- go
      b.formatting.gofmt,
      b.formatting.goimports,

      -- gitcommit, markdown
      b.diagnostics.write_good.with { filetypes = { "gitcommit", "markdown" } },

      b.diagnostics.rubocop,
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
