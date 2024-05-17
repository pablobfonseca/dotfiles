return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>tt", mode = "n", desc = "Trouble Toggle", "<cmd>TroubleToggle document_diagnostics<cr>" },
  },
  opts = {
    auto_close = true,
  },
}
