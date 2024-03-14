return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>Oo",
      mode = "n",
      ":ObsidianOpen<cr>",
      desc = "Open current note in the Obsidian app",
    },
    {
      "<leader>On",
      mode = "n",
      ":ObsidianNew",
      desc = "New note",
    },
    {
      "<leader>Ot",
      mode = "n",
      ":ObsidianTemplate<cr>",
      desc = "Insert template",
    },
    {
      "<leader>Of",
      mode = "n",
      ":ObsidianQuickSwitch<cr>",
      desc = "Find a note",
    },
  },
  opts = {
    workspaces = {
      {
        name = "SecondBrain",
        path = os.getenv "OBSIDIAN_VAULTS" .. "/SecondBrain",
      },
    },
    completions = {
      nvim_cmp = true,
      min_chars = 2,
    },
    new_notes_location = "notes_subdir",
  },
  ui = {
    enable = true,
  },
  templates = {
    subdir = "Templates",
    date_format = "%Y-%m-%d",
  },
}
