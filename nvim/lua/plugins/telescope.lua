return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      keys = {
        {
          "<C-x>d",
          mode = "n",
          "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
          desc = "Telescope File Browser",
        },
        {
          "<space>e",
          mode = "n",
          "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
          desc = "Telescope File Browser",
        },
      },
    },
  },
  config = function()
    require "custom.telescope"
  end,
}
