vim.pack.add({ "https://github.com/folke/tokyonight.nvim.git" }, { load = true })
require("tokyonight").setup {
  style = "night",
  light_style = "day",
  styles = {
    floats = "normal", -- use Normal background instead of dark for floats
  },
  on_highlights = function(hl, c)
    hl.FloatBorder = { fg = c.border_highlight, bg = c.bg_float }
  end,
}
vim.cmd.colorscheme "tokyonight-night"
