require("catppuccin").setup {
  flavour = "mocha",
  background = {
    light = "latte",
    dark = "mocha",
  },
  integrations = {
    cmp = true,
    blink_cmp = true,
    lsp_saga = true,
    mason = true,
    octo = true,
    which_key = true,
  },
  term_colors = true,
}

vim.cmd.colorscheme "catppuccin"
