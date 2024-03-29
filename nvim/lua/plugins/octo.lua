return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<C-c>ors", mode = "n", desc = "[O]cto [R]eview [S]tart",  "<cmd>Octo review start<cr>" },
    { "<C-c>orS", mode = "n", desc = "[O]cto [R]eview [S]ubmit", "<cmd>Octo review submit<cr>" },
    { "<C-c>opm", mode = "n", desc = "[O]cto [P]R [M]erge",      "<cmd>Octo pr merge<cr>" },
    { "<C-c>opl", mode = "n", desc = "[O]cto [P]R [L]ist",       "<cmd>Octo pr list<cr>" },
    { "<C-c>opc", mode = "n", desc = "[O]cto [P]R [C]reate",     "<cmd>Octo pr create<cr>" },
    { "<C-c>oil", mode = "n", desc = "[O]cto My [I]ssue [L]ist", "<cmd>Octo issue list assignee=pablobfonseca<cr>" },
    { "<C-c>oiL", mode = "n", desc = "[O]cto [I]ssue [L]ist",    "<cmd>Octo issue list<cr>" },
  },
  opts = {},
}
