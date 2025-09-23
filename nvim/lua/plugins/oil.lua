vim.pack.add { "https://github.com/stevearc/oil.nvim" }

local oil = require "oil"
oil.setup {
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
  columns = { "icon" },
  keymaps = {
    ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-v>"] = { "actions.select", opts = { vertical = true } },
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      return name == ".." or name == ".git"
    end,
  },
}

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "<C-x>d", function()
  require("oil").toggle_float()
end)
