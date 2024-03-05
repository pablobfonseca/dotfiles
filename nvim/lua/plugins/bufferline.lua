return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = false,
  keys = {
    { "<Tab>", mode = "n", ":bnext<cr>", desc = "Next buffer" },
    { "<S-Tab>", mode = "n", ":bprevious<cr>", desc = "Previous buffer" },
    { "<leader>x", mode = "n", desc = "Close buffer", silent = true, ":bd!<cr>" },
  },
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      separator_style = "slant",
    },
  },
}
