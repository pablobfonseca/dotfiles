return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      columns = { "icon" },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
      },
    }

    vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
    vim.keymap.set("n", "<space>-", require("oil").toggle_float)
  end,
}
