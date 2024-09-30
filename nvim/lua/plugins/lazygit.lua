return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  keys = {
    {
      "<C-x>g",
      mode = "n",
      desc = "Open lazygit",
      "<cmd>LazyGitCurrentFile<cr>",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
