return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ors", mode = "n", desc = "Octo Review Start",  "<cmd>Octo review start<cr>" },
    { "<leader>orS", mode = "n", desc = "Octo Review Submit", "<cmd>Octo review submit<cr>" },
  },
  opts = {},
}
