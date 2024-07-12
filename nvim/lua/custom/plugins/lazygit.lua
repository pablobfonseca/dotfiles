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
      desc = "Open fugitive",
      "<cmd>LazyGitCurrentFile<cr>",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
