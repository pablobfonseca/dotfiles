return {
  "folke/which-key.nvim",
  keys = { "<leader>", "<c-r>", "<c-w>", "<c-c>", '"', "'", "`", "c", "v", "g" },
  cmd = "WhichKey",
  config = function()
    local which_key = require "which-key"
    which_key.setup {}

    which_key.register {
      ["<C-c>o"] = { name = "[O]cto", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]sp", _ = "which_key_ignore" },
      ["<C-c>n"] = { name = "[N]eorg", _ = "which_key_ignore" },
      ["<C-c>w"] = { name = "[W]orktrees", _ = "which_key_ignore" },
    }
  end,
}
