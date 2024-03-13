return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "SecondBrain",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain",
      },
      {
        name = "Notes",
        path = "~/Dropbox/notes",
      },
    },
    completions = {
      nvim_cmp = true,
      min_chars = 2,
    },
    new_notes_location = "current_dir",
  },
  ui = {
    enable = true,
  },
}
