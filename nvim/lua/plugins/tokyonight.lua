return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    light_style = "day",
    styles = {
      floats = "normal",
    },
    on_highlights = function(hl, c)
      hl.FloatBorder = { fg = c.border_highlight, bg = c.bg_float }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme "tokyonight-night"
  end,
}
