return {
  "NeogitOrg/neogit",
  branch = "nightly",
  keys = {
    { "<C-x>g", "<cmd>Neogit cwd=%:p:h<cr>", { desc = "Open Neogit" } },
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
