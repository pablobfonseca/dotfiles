return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = false,
  keys = {
    { "<Tab>", mode = "n", ":bnext<cr>", desc = "Next buffer" },
    { "<S-Tab>", mode = "n", ":bprevious<cr>", desc = "Previous buffer" },
  },
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {},
}
