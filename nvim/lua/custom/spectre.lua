require("spectre").setup {
  live_update = true,
}

vim.keymap.set("n", "<leader>S", function()
  require("spectre").open()
end, { desc = "Open Spectre" })

vim.keymap.set({ "n", "v" }, "<leader>sW", function()
  require("spectre").open_file_search { select_word = true }
end, { desc = "Search on current file" })

vim.keymap.set({ "n", "v" }, "<leader>sw", function()
  require("spectre").open_visual { select_word = true }
end, { desc = "Search current word" })
