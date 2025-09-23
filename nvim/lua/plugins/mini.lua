vim.pack.add {
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/nvim-mini/mini.surround" },
}
require("mini.ai").setup {
  n_lines = 500,
}

require("mini.surround").setup()
