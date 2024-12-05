local neogit = require "neogit"
neogit.setup {}

vim.keymap.set("n", "<C-x>g", function()
  neogit.open { cwd = "%:p:h" }
end, { desc = "Neogit" })
