return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "tokyonight",
      component_separators = "",
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_b = { "branch", "diff" },
      lualine_x = { "diagnostics", "filetype" },
    },
  },
}
