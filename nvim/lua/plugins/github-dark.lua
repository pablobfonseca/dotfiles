return {
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 1000,
  enabled = false, -- enable to use github theme instead of tokyonight
  opts = {},
  config = function(_, opts)
    require("github-theme").setup(opts)
    vim.cmd.colorscheme "github_dark"
  end,
}
