return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>tt", mode = "n", desc = "Diagnostics (Trouble)", "<cmd>Trouble diagnostics toggle<cr>" },
    {
      "<leader>tb",
      mode = "n",
      desc = "Buffer Diagnostics (Trouble)",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    },
    { "<leader>ts", mode = "n", desc = "Symbols (Trouble)",     "<cmd>Trouble symbols toggle focus=false<cr>" },
    {
      "<leader>tl",
      mode = "n",
      desc = "LSP (Trouble)",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    },
    {
      "<leader>tq",
      mode = "n",
      desc = "Quickfix list (Trouble)",
      "<cmd>Trouble qflist toggle<cr>",
    },
  },
  opts = {
    auto_close = true,
  },
}
