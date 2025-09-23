vim.pack.add({ "https://github.com/folke/tokyonight.nvim.git" }, { load = true })
require("tokyonight").setup {
  style = "night",
  light_style = "day",
}
vim.cmd.colorscheme "tokyonight-night"
