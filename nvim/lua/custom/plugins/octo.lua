return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require "custom.octo"
  end,
}
