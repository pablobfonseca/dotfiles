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
    "typescript-language-server",
    "prettier",
    "prettierd",
    "tailwindcss-language-server",
    "fixjson",

    -- elm stuff
    "elm-format",
    "elm-language-server",

    -- yaml
    "yaml-language-server",

    -- haskell
    "haskell-language-server",

    -- python stuff
    "pyright",
    "python-lsp-server",

    -- ocaml stuff
    "ocamllsp",

    -- ruby stuff
    "rubocop",
    "ruby_lsp",
    "rubyfmt",

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
