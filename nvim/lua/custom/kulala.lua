require("kulala").setup()

vim.keymap.set("n", "<leader>rm", function()
  require("kulala").scratchpad()
end, { desc = "Open request scratchpad" })
vim.keymap.set("n", "<C-c><C-c>", function()
  require("kulala").run()
end, { desc = "Run request" })
