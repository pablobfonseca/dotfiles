return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>OT",
      mode = "n",
      ":ObsidianOpen todo<cr>",
      desc = "Obsidian TODO",
    },
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
      ":ObsidianTags<cr>",
      desc = "Search for tags",
    },
    {
      "<leader>Of",
      mode = "n",
      ":ObsidianQuickSwitch<cr>",
      desc = "Find a note",
    },
    {
      "<leader>Os",
      mode = "n",
      ":ObsidianSearch<cr>",
      desc = "Search notes",
    },
  },
  opts = {
    workspaces = {
      {
        name = "SecondBrain",
        path = os.getenv "OBSIDIAN_VAULTS" .. "/SecondBrain",
      },
    },
    notes_subdir = "0 - Inbox",
    completions = {
      nvim_cmp = true,
      min_chars = 2,
    },
    new_notes_location = "notes_subdir",
    ui = {
      enable = true,
    },
    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d",
    },
    follow_url_func = function(url)
      vim.fn.jobstart { "open", url }
    end,
  },
}
