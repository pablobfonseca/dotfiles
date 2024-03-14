return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "c",
        "css",
        "dockerfile",
        "gitcommit",
        "go",
        "html",
        "http",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "norg",
        "norg_meta",
        "ocaml",
        "python",
        "ruby",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      },
      indent = {
        enable = true,
      },
      endwise = {
        enable = true,
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        -- keymaps = {
        --   init_selection = "gnn", -- set to `false` to disable one of the mappings
        --   node_incremental = "grn",
        --   scope_incremental = "grc",
        --   node_decremental = "grm",
        -- },
      },
    }
  end,
}
