local oil = require "oil"
oil.setup {
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
  columns = { "icon" },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      return name == ".." or name == ".git"
    end,
  },
  keymaps = {
    gs = {
      callback = function()
        local prefills = { paths = oil.get_current_dir() }

        local grug_far = require "grug-far"
        if not grug_far.has_instance "expolorer" then
          grug_far.open {
            instanceName = "explorer",
            prefills = prefills,
            staticTitle = "Find and Replace from Explorer",
          }
        else
          grug_far.open_instance "explorer"
          grug_far.update_instance_prefills("explorer", prefills, false)
        end
      end,
      desc = "oil: Search in directory",
    },
  },
}

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "<space>-", function()
  require("oil").toggle_float()
end)
