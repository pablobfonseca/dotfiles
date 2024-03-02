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
        "ruby",
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

        additional_vim_regex_highlighting = { "org" },
      },
    }
  end,
}
