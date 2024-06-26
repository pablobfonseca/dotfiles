return {
  "folke/which-key.nvim",
  keys = { "<leader>", "<c-r>", "<c-w>", "<c-c>", '"', "'", "`", "c", "v", "g" },
  cmd = "WhichKey",
  config = function()
    local which_key = require "which-key"
    which_key.setup {}

    which_key.register {
      ["<C-c>o"] = { name = "[O]cto", _ = "which_key_ignore" },
      ["<C-c>or"] = { name = "[R]eview", _ = "which_key_ignore" },
      ["<C-c>op"] = { name = "[P]R", _ = "which_key_ignore" },
      ["<C-c>oi"] = { name = "[I]ssue", _ = "which_key_ignore" },
      ["<leader>O"] = { name = "[O]bsidian", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]sp", _ = "which_key_ignore" },
      ["<C-c>n"] = { name = "[N]eorg", _ = "which_key_ignore" },
      ["<C-c>w"] = { name = "[W]orktrees", _ = "which_key_ignore" },
      ["<C-c>h"] = { name = "[H]arpoon", _ = "which_key_ignore" },
      ["<C-c>t"] = { name = "[T]mux Runner", _ = "which_key_ignore" },
      ["<C-c>d"] = { name = "[D]ebugger", _ = "which_key_ignore" },
      ["<leader>T"] = { name = "[T]est", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]rouble", _ = "which_key_ignore" },
      ["<C-c>D"] = { name = "[D]iff View", _ = "which_key_ignore" },
    }
  end,
}
