return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose" },
  event = "VeryLazy",
  keys = {
    {
      "<C-c>Do",
      mode = "n",
      desc = "Diff View Open",
      "<cmd>DiffviewOpen<cr>",
    },
    {
      "<C-c>Dc",
      mode = "n",
      desc = "Diff View Close",
      "<cmd>DiffviewClose<cr>",
    },
    {
      "<C-c>Df",
      mode = "n",
      desc = "Diff View File History",
      "<cmd>DiffviewFileHistory<cr>",
    },
  },
}
