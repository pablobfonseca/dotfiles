return {
  "lewis6991/gitsigns.nvim",
  event = "User FilePost",
  keys = {
    {
      "<leader>b",
      mode = "n",
      desc = "Blame line",
      function()
        require("gitsigns").blame_line()
      end,
    },
  },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "│" },
    },
  },
}
