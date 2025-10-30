vim.pack.add { "https://github.com/mistweaverco/kulala.nvim" }

require("kulala").setup()

local set = vim.keymap.set

set("n", "<leader>rm", function()
  require("kulala").scratchpad()
end, { desc = "Open request scratchpad" })
set("n", "<C-c><C-c>", function()
  require("kulala").run()
end, { desc = "Run request" })
set("n", "<C-c>kt", function()
  require("kulala").toggle_view()
end, { desc = "Kulala Toggle View" })
set("n", "<C-c>ks", function()
  require("kulala").search()
end, { desc = "Kulala Search" })
set("n", "<C-c>kS", function()
  require("kulala").set_selected_env()
end, { desc = "Kulala select env" })
