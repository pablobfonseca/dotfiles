return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      max_concurrent_installers = 10,
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "prettier",
        "prettierd",
        "tailwindcss-language-server",
        "fixjson",
        "js-debug-adapter",

        -- elm
        "elmls",

        -- ruby stuff
        "solargraph",
        "rubocop",

        -- elm stuff
        "elm-format",
        "elm-language-server",

        -- ocaml
        "ocamlformat",

        -- python stuff
        "pyright",
        "python-lsp-server",
        "black",

        -- go stuff
        "gopls",
        "goimports",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local lsp_zero = require "lsp-zero"
      require("mason-lspconfig").setup {
        ensure_installed = require "pablobfonseca.config.lsp_servers",
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
          jsonls = function()
            require("lspconfig").jsonls.setup {
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            }
          end,
        },
      }
    end,
  },
}
