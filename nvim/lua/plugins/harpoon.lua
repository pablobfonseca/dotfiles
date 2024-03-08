return {
  "theprimeagen/harpoon",
  config = function()
    vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file, { desc = "Add file to harpoon" })
    vim.keymap.set("n", "<C-c>h", require("harpoon.ui").toggle_quick_menu, { desc = "Toggle harpoon" })
  end,
}
