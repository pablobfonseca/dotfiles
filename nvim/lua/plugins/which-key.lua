return {
  "folke/which-key.nvim",
  keys = { "<leader>", "<c-r>", "<c-w>", "<c-c>", '"', "'", "`", "c", "v", "g" },
  cmd = "WhichKey",
  config = function()
    local which_key = require "which-key"
    which_key.setup {}

    which_key.add {
      { "<C-c>o", group = "[O]cto" },
      { "<C-c>or", group = "[R]eview" },
      { "<C-c>op", group = "[P]R" },
      { "<C-c>oi", group = "[I]ssue" },
      { "<leader>O", group = "[O]bsidian" },
      { "<leader>l", group = "[L]sp" },
      { "<C-c>n", group = "[N]eorg" },
      { "<C-c>w", group = "[W]orktrees" },
      { "<C-c>h", group = "[H]arpoon" },
      { "<C-c>t", group = "[T]mux Runner" },
      { "<C-c>d", group = "[D]ebugger" },
      { "<leader>T", group = "[T]est" },
      { "<leader>t", group = "[T]rouble" },
      { "<leader>c", group = "[C]odecompanion" },
      { "<C-c>D", group = "[D]iff View" },
    }
  end,
}
