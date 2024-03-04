return {
  "nvim-neorg/neorg",
  ft = "norg",
  build = ":Neorg sync-parsers",
  dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
  keys = {
    { "<C-x>w", mode = "n", desc = "Change neorg workspace", "<cmd>Telescope neorg switch_workspace<cr>" },
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
          },
        },
      },
    },
  },
}
