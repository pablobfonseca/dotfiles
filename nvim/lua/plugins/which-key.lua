return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local which_key = require "which-key"
    which_key.setup(opts)

    vim.keymap.set("n", "<leader>?", function()
      which_key.show { global = false }
    end, { desc = "Buffer Local Keymaps (which-key)" })

    which_key.add {
      { "<leader>a", group = "ai" },
    }
  end,
}
