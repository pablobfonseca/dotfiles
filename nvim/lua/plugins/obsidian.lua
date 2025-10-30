vim.pack.add {
  { src = "https://github.com/epwalsh/obsidian.nvim", version = "main" },
}

require("obsidian").setup {
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
}

vim.keymap.set("n", "<leader>OT", ":ObsidianOpen todo<cr>", { desc = "Obsidian TODO" })
vim.keymap.set("n", "<leader>Oo", ":ObsidianOpen<cr>", { desc = "Open current note in the Obsidian app" })
vim.keymap.set("n", "<leader>On", ":ObsidianNew", { desc = "New note" })
vim.keymap.set("n", "<leader>Ot", ":ObsidianTags<cr>", { desc = "Search for tags" })
vim.keymap.set("n", "<leader>Of", ":ObsidianQuickSwitch<cr>", { desc = "Find a note" })
vim.keymap.set("n", "<leader>Os", ":ObsidianSearch<cr>", { desc = "Search notes" })
