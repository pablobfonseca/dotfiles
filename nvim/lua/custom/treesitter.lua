require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "css",
    "dockerfile",
    "elm",
    "gitcommit",
    "go",
    "haskell",
    "html",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "ocaml",
    "python",
    "swift",
    "ruby",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
  sync_install = false,
  auto_install = true,
  incremental_selection = {
    enable = true,
    keymaps = {
      -- init_selection = "gnn", -- set to `false` to disable one of the mappings
      -- node_incremental = "grn",
      -- scope_incremental = "grc",
      -- node_decremental = "grm",
    },
  },
}

vim.treesitter.language.register("markdown", "octo")
