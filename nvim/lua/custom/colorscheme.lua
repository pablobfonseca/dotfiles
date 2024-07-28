require("tokyonight").setup {
  style = "moon",
  transparent = true,
  terminal_colors = true,
  plugins = {
    telescope = true,
  },
}

vim.cmd.colorscheme "tokyonight"
