return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup {
      dim_inactive = true,
    }

    vim.cmd.colorscheme "tokyonight-storm"
  end,
}
