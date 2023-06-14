local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
      {
        "folke/lua-dev.nvim",
      },
      {
        "RRethy/vim-illuminate",
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup {}
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>S",
        function()
          require("spectre").open()
        end,
        desc = "Open spectre",
        mode = { "n" },
      },
    },
    opts = overrides.spectre,
    config = function()
      require("spectre").setup {}
    end,
  },
  {
    "yorickpeterse/nvim-window",
    keys = {
      {
        "<M-o>",
        function()
          require("nvim-window").pick()
        end,
        desc = "Pick window",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      require "custom.configs.fugitive"
    end,
  },
  {
    "sindrets/diffview.nvim",
    lazy = false,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "pablobfonseca/stackmap.nvim",
    lazy = false,
    dir = "~/code/stackmap.nvim/",
  },
  {
    "tpope/vim-eunuch",
    lazy = false,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    keys = {
      {
        "<leader>llf",
        "<cmd>Lspsaga lsp_finder<cr>",
        desc = "[L]spSaga [L] [F]inder",
        mode = { "n" },
      },
      {
        "<leader>lca",
        "<cmd>Lspsaga lsp_code_action<cr>",
        desc = "[L]sp [C]ode [A]ction",
        mode = { "n" },
      },
      {
        "<leader>lsl",
        "<cmd>Lspsaga show_line_diagnostics<cr>",
        desc = "[L]sp [S]how [L]ine diagnostics",
        mode = { "n" },
      },
      {
        "<leader>lsb",
        "<cmd>Lspsaga show_buffer_diagnostics<cr>",
        desc = "[L]sp [S]how [B]uffer diagnostics",
        mode = { "n" },
      },
      {
        "<leader>lh",
        "<cmd>Lspsaga hover_doc<cr>",
        desc = "[L]sp [H]over",
        mode = { "n" },
      },
    },
    config = function()
      require("lspsaga").setup {}
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>tt",
        "<cmd>TroubleToggle<cr>",
        desc = "[T]rouble [T]oggle",
        mode = { "n" },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = overrides.copilot,
    config = function()
      require("copilot").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
      {
        "hrsh7th/cmp-buffer",
        config = function()
          local cmp = require "cmp"
          cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer" },
            },
          })
        end,
      },
      {
        "hrsh7th/cmp-cmdline",
        lazy = false,
        config = function()
          local cmp = require "cmp"
          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = "path" },
            }, {
              {
                name = "cmdline",
                option = {
                  ignore_cmds = { "Man", "!" },
                },
              },
            }),
          })
        end,
      },
    },
    opts = {
      sources = {
        { name = "nvim_lsp", group_index = 2 },
        { name = "copilot", group_index = 2 },
        { name = "luasnip", group_index = 2 },
        { name = "buffer", group_index = 2 },
        { name = "nvim_lua", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "cmdline", group_index = 2 },
      },
    },
  },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup {}
      require("telescope").load_extension "textcase"
    end,
    keys = {
      {
        "<leader>tct",
        "<cmd>TextCaseOpenTelescope<cr>",
        desc = "[T]ext [C]ase [T]elescope",
        mode = { "n", "v" },
      },
      {
        "<leader>tcq",
        "<cmd>TextCaseOpenTelescopeQuickChange<cr>",
        desc = "[T]ext [C]ase [Q]uickChange",
        mode = { "n" },
      },
      {
        "<leader>tcl",
        "<cmd>TextCaseOpenTelescopeLSPChange<cr>",
        desc = "[T]ext [C]ase [L]SPChange",
        mode = { "n" },
      },
    },
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
