return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  keys = {
    { "<leader>u", mode = "n", desc = "Undo history", "<cmd>Telescope undo<cr>" },
  },
  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup {
      extensions = {
        undo = {
          use_delta = true,
          use_custom_command = nil,
          side_by_side = false,
          diff_context_lines = vim.o.scrolloff,
          entry_format = "state #$ID, $STAT, $TIME",
          time_format = "",
          saved_only = false,
        },
      },
    }
    telescope.load_extension "undo"
  end,
}
