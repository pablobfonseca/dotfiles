return {
  "nvim-neorg/neorg",
  ft = "norg",
  build = ":Neorg sync-parsers",
  dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
  keys = {
    { "<C-c>nw", mode = "n", desc = "Change neorg workspace",     "<cmd>Telescope neorg switch_workspace<cr>" },
    { "<C-c>nt", mode = "n", desc = "Toggle table of contents",   "<cmd>Neorg toc<cr>" },
    { "<C-c>nf", mode = "n", desc = "Telescope find neorg files", "<cmd>Telescope neorg find_norg_files<cr>" },
  },
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {
        config = {
          folds = false,
        },
      },
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.integrations.telescope"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/Dropbox/notes",
            dotfiles = "~/.dotfiles",
            second_brain = "~/Dropbox/second_brain",
          },
        },
      },
    },
  },
}
