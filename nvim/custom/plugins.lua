local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
      {
        "folke/neodev.nvim",
        opts = overrides.neodev,
      },
      {
        "RRethy/vim-illuminate",
      },
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
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
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
    dependencies = {
      {
        "hrsh7th/cmp-buffer",
        config = function()
          local cmp = require "cmp"
          -- cmp.event:on("menu_opened", function()
          --   vim.b.copilot_suggestion_hidden = true
          -- end)
          -- cmp.event:on("menu_closed", function()
          --   vim.b.copilot_suggestion_hidden = false
          -- end)
          cmp.setup.cmdline({ "/", "?" }, {
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
    init = function()
      require("core.utils").load_mappings "spectre"
    end,
    opts = overrides.spectre,
  },
  {
    "yorickpeterse/nvim-window",
    lazy = false,
    init = function()
      require("core.utils").load_mappings "nvim_window"
    end,
    config = function()
      require("nvim-window").setup {}
    end,
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
    "sindrets/diffview.nvim",
    lazy = false,
  },
  {
    "iamcco/markdown-preview.nvim",
    lazy = false,
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "chrisgrieser/nvim-genghis",
    lazy = false,
    dependencies = "stevearc/dressing.nvim",
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {},
  },
  {
    "nvim-telescope/telescope-project.nvim",
    init = function()
      require("core.utils").load_mappings "telescope_project"
    end,
    opts = overrides.telescope_project,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    init = function()
      require("core.utils").load_mappings "lsp_saga"
    end,
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
    init = function()
      require("core.utils").load_mappings "trouble"
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = overrides.copilot,
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = overrides.rest,
    ft = { "restmode" },
    init = function()
      require("core.utils").load_mappings "rest"
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      require("core.utils").load_mappings "octo"
    end,
    config = function()
      require("octo").setup()
    end,
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    init = function()
      require("core.utils").load_mappings "neorg"
    end,
    dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
    opts = overrides.neorg,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup {}
      require("telescope").load_extension "textcase"
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
  },
  {
    "smoka7/hop.nvim",
    lazy = false,
    version = "*",
    opts = {},
    init = function()
      require("core.utils").load_mappings "hop"
    end,
  },
  {
    "pablobfonseca/stackmap.nvim",
    dir = "~/code/nvim_plugins/stackmap.nvim",
    lazy = false,
  },
  {
    "pablobfonseca/impatient.nvim",
    dir = "~/code/nvim_plugins/impatient.nvim",
    ft = { "html" },
  },
  {
    "rafcamlet/nvim-luapad",
    cmd = "Luapad",
  },
  {
    "b0o/schemastore.nvim",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    cmd = "Refactor",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
  {
    "NeogitOrg/neogit",
    init = function()
      require("core.utils").load_mappings "neogit"
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    config = true,
  },
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^3", -- Recommended
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  },
  {
    "neovimhaskell/haskell-vim",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function()
      vim.api.nvim_set_var("haskell_enable_quantification", 1)
      vim.api.nvim_set_var("haskell_enable_recursivedo", 1)
      vim.api.nvim_set_var("haskell_enable_arrowsyntax", 1)
      vim.api.nvim_set_var("haskell_enable_pattern_synonyms", 1)
      vim.api.nvim_set_var("haskell_enable_typeroles", 1)
      vim.api.nvim_set_var("haskell_enable_static_pointers", 1)
      vim.api.nvim_set_var("haskell_backpack", 1)
    end,
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
