return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup {}

      vim.cmd.colorscheme "gruvbox"
    end,
  },
  {
    "maxmx03/dracula.nvim",
    enabled = false,
    config = function()
      require("dracula").setup {}
    end,
  },
}
