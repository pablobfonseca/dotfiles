return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    keys = {
      { "<leader>OT", ":ObsidianOpen todo<cr>", desc = "Obsidian TODO" },
      { "<leader>Oo", ":ObsidianOpen<cr>", desc = "Open current note in Obsidian" },
      { "<leader>On", ":ObsidianNew", desc = "New note" },
      { "<leader>Ot", ":ObsidianTags<cr>", desc = "Search for tags" },
      { "<leader>Of", ":ObsidianQuickSwitch<cr>", desc = "Find a note" },
      { "<leader>Os", ":ObsidianSearch<cr>", desc = "Search notes" },
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
        enable = false,
      },
      templates = {
        subdir = "Templates",
        date_format = "%Y-%m-%d",
      },
      follow_url_func = function(url)
        vim.fn.jobstart { "open", url }
      end,
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {},
  },
}
