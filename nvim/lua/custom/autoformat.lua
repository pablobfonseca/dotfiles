local setup = function()
  -- Autoformatting setup

  local conform = require "conform"
  conform.setup {
    formatters_by_ft = {
      lua = { "stylua" },
      typescript = { "prettierd", "deno_fmt", stop_after_first = true },
      typescriptreact = { "prettierd", "deno_fmt", stop_after_first = true },
      javascript = { "prettierd" },
      markdown = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      elm = { "elm_format" },
      ruby = { "rubocop" },
      go = { "gofmt", "goimports" },
    },
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
    callback = function(args)
      require("conform").format {
        bufnr = args.buf,
        lsp_fallback = true,
        quiet = true,
      }
    end,
  })
end

setup()

return { setup = setup }
