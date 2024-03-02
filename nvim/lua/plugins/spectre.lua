return {
  "nvim-pack/nvim-spectre",
  keys = {
    {
      "<leader>S",
      mode = "n",
      desc = "Open Spectre",
      function()
        require("spectre").open()
      end,
    },
    {
      "<leader>sw",
      mode = "n",
      desc = "Search current word",
      function()
        require("spectre").open_visual({ select_word = true })
      end,
    },
  },
  opts = {
    live_update = true,
  },
}
