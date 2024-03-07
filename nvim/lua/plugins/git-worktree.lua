return {
  "ThePrimeagen/git-worktree.nvim",
  keys = {
    {
      "<C-c>ww",
      mode = "n",
      desc = "Git worktrees [C]heckout",
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
    },
    {
      "<C-c>wc",
      mode = "n",
      desc = "Git worktrees [C]heckout",
      function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
    },
  },
  config = function()
    require("git-worktree").setup {
      update_on_change_command = "Telescope git_files",
    }
    require("telescope").load_extension "git_worktree"
  end,
}
