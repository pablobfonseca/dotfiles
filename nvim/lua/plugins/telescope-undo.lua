return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  keys = {
    {
      "<leader>u",
      mode = "n",
      desc = "Undo history",
      function()
        require("telescope").extensions.undo.undo()
      end,
    },
  },
  config = function()
    local telescope = require "telescope"
    telescope.setup {
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    }
    telescope.load_extension "undo"
  end,
}
