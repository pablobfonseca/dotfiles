return {
  "yorickpeterse/nvim-window",
  event = "VeryLazy",
  keys = {
    {
      "<M-o>",
      mode = "n",
      desc = "Pick a window",
      function()
        require("nvim-window").pick()
      end,
    },
  },
  config = function()
    require("nvim-window").setup {}
  end,
}
