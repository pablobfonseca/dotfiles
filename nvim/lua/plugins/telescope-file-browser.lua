return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    {"<C-d>", mode = "n", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "Telescope File Browser"},
    {"<space>e", mode = "n", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "Telescope File Browser"},
  },
  config = function()
    local telescope = require "telescope"
    telescope.setup({
      extensions = {
        file_browser = {
          hijack_netrw = true,
          display_stat = false,
        }
      }
    })
    telescope.load_extension("file_browser")
  end
}
