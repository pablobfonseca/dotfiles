vim.pack.add { "https://github.com/williamboman/mason.nvim" }
vim.pack.add { "https://github.com/jay-babu/mason-nvim-dap.nvim" }

require("mason").setup {
  ensure_installed = {
    "delve",
    "js-debug-adapter",
    "fixjson",
    "goimports",
    "gopls",
    "json-lsp",
    "lua-language-server",
    "prettier",
    "prettierd",
    "stylua",
    "tailwindcss-language-server",
    "typescript-language-server",
  },
}
