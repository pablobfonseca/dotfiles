return {
  "NeogitOrg/neogit",
  keys = {
    { "<C-x>g", "<cmd>Neogit<cr>", { desc = "Open Neogit" } },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    integrations = {
      diffview = true,
      telescope = true,
    },
  },
}
