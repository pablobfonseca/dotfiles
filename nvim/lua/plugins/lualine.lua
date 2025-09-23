vim.pack.add { "https://github.com/nvim-lualine/lualine.nvim" }
vim.pack.add { "https://github.com/nvim-tree/nvim-web-devicons" }

require("lualine").setup {
  options = {
    theme = "tokyonight",
    component_separators = "",
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_b = { "branch", "diff" },
    lualine_x = { "diagnostics", "filetype" },
  },
}
