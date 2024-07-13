local opts = {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  max_concurrent_installers = 10,
  ensure_installed = {
    -- Lua stuff
    "lua-language-server",
    "stylua",

    -- Web dev stuff
    "css-lsp",
    "html-lsp",
    "emmet-ls",
    "typescript-language-server",
    "prettier",
    "prettierd",
    "tailwindcss-language-server",
    "fixjson",

    -- ruby stuff
    "solargraph",
    "rubocop",
    "ruby-lsp",

    -- elm stuff
    "elm-format",
    "elm-language-server",

    -- yaml
    "yaml-language-server",

    -- python stuff
    "pyright",
    "python-lsp-server",
    "black",

    -- go stuff
    "gopls",
    "goimports",
    "delve",
  },
}

require("mason").setup(opts)

vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
end, {})
