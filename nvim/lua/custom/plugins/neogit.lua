return {
  "NeogitOrg/neogit",
  keys = {
    {
      "<C-x>g",
      mode = "n",
      desc = "Open Neogit",
      function()
        require("neogit").open { cwd = vim.fn.expand "%:p:h" }
      end,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    integrations = {
      diffview = true,
      telescope = true,
    },
  },
}
