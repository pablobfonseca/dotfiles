vim.pack.add { "https://github.com/folke/which-key.nvim" }

local which_key = require "which-key"
which_key.setup {}

vim.keymap.set("n", "<leader>?", function()
  which_key.show { global = false }
end, { desc = "Buffer Local Keymaps (which-key)" })

which_key.add {
  { "<leader>a", group = "ai" },
}
