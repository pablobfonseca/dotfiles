return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  keys = {
    { "<leader>rm", function() require("kulala").scratchpad() end, desc = "Open request scratchpad" },
    { "<C-c><C-c>", function() require("kulala").run() end, desc = "Run request" },
    { "<C-c>kt", function() require("kulala").toggle_view() end, desc = "Kulala Toggle View" },
    { "<C-c>ks", function() require("kulala").search() end, desc = "Kulala Search" },
    { "<C-c>kS", function() require("kulala").set_selected_env() end, desc = "Kulala select env" },
  },
  opts = {},
}
