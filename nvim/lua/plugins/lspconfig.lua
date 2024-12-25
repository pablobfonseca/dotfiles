return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "saghen/blink.cmp" },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true },
      {
        "williamboman/mason.nvim",
        dependencies = {
          { "stevearc/dressing.nvim" },
          {
            "jay-babu/mason-nvim-dap.nvim",
            event = "VeryLazy",
            opts = {
              ensure_installed = {
                "delve",
                "js-debug-adapter",
              },
            },
          },
        },
      },
      { "williamboman/mason-lspconfig" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "j-hui/fidget.nvim", opts = {} },
      { "stevearc/conform.nvim" },
      { "b0o/schemastore.nvim" },
    },
    config = function()
      -- Don't do LSP on Obsidian mode
      if vim.g.obsidian then
        return
      end

      local lspconfig = require "lspconfig"

      local servers = {
        bashls = true,
        gopls = {
          settings = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionalTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
        lua_ls = {
          server_capabilities = {
            semanticTokensProvider = vim.NIL,
          },
        },
        rust_analyzer = true,
        pyright = true,
        cssls = true,
        elmls = true,
        harper_ls = {
          filetypes = {
            "markdown",
            "gitcommit",
            "NeogitCommitMessage",
          },
        },
        html = true,
        jsonls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            schemaStore = {
              enable = false,
              url = "",
            },
          },
        },
        ocamllsp = {
          manual_install = true,
          cmd = { "opam", "exec", "--", "dune", "exec", "ocamllsp" },
          settings = {
            codelens = { enable = true },
            inlayHints = { enable = true },
            syntaxDocumentation = { enable = true },
          },
          server_capabilities = { semanticTokensProvider = false },
        },
        pylsp = true,
        ruby_lsp = true,
        tailwindcss = true,
        hls = {
          filetypes = { "haskell", "lhaskell", "cabal" },
        },
        ts_ls = {
          root_dir = require("lspconfig").util.root_pattern "package.json",
          single_file = false,
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        max_concurrent_installers = 10,
      }
      local ensure_installed = require "pablobfonseca.config.lsp_servers"
      vim.list_extend(ensure_installed, servers_to_install)

      require("mason-tool-installer").setup {
        ensure_installed = ensure_installed,
      }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities),
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local builtin = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0, desc = "Go to definition" })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = -1, desc = "Go to references" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0, desc = "Go to declarations" })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0, desc = "Type definitions" })
          vim.keymap.set("n", "H", vim.lsp.buf.hover, { buffer = 0, desc = "Lsp hover" })

          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = 0, desc = "Lsp rename" })
          vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, { buffer = 0, desc = "Lsp code action" })
          vim.keymap.set(
            "n",
            "<leader>ds",
            builtin.lsp_document_symbols,
            { buffer = 0, desc = "Telescope document symbols" }
          )

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      require("custom.autoformat").setup()

      vim.diagnostic.config { virtual_text = true }

      vim.keymap.set("", "<leader>L", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp lines" })
    end,
  },
}
