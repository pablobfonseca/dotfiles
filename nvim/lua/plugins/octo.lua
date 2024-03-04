return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<C-c>ors", mode = "n", desc = "Octo Review Start", "<cmd>Octo review start<cr>" },
    { "<C-c>orS", mode = "n", desc = "Octo Review Submit", "<cmd>Octo review submit<cr>" },
    { "<C-c>opm", mode = "n", desc = "Octo PR Merge", "<cmd>Octo pr merge<cr>" },
    { "<C-c>opl", mode = "n", desc = "Octo PR List", "<cmd>Octo pr list<cr>" },
    { "<C-c>oil", mode = "n", desc = "Octo Issue List", "<cmd>Octo issue list<cr>" },
  },
  opts = {},
}
