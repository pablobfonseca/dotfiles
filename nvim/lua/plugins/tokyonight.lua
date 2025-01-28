return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    light_style = "day",
  },
  config = function()
    require "custom.colorscheme"
  end,
}
