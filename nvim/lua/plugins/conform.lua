return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      html = { "prettierd", "deno_fmt", stop_after_first = true },
      typescript = { "prettierd", "deno_fmt", stop_after_first = true },
      typescriptreact = { "prettierd", "deno_fmt", stop_after_first = true },
      javascript = { "prettierd" },
      python = { "autopep8", "black", stop_after_first = true },
      markdown = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      elm = { "elm_format" },
      go = { "gofmt", "goimports" },
    },
    format_on_save = {
      lsp_fallback = true,
      quiet = true,
    },
  },
}
