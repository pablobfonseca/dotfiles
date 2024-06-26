return {
  "akinsho/bufferline.nvim",
  lazy = false,
  keys = {
    { "<Tab>", mode = "n", ":bnext<cr>", desc = "Next buffer", silent = true },
    { "<S-Tab>", mode = "n", ":bprevious<cr>", desc = "Previous buffer", silent = true },
    { "<leader>x", mode = "n", desc = "Close buffer", silent = true, ":bd!<cr>" },
    {
      "<M-x>1",
      mode = "n",
      desc = "Keep only current buffer",
      silent = true,
      "<cmd>BufferLineCloseOthers<cr>",
    },
  },
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      separator_style = "slant",
    },
  },
}
