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
      "<leader>sW",
      mode = { "n", "v" },
      desc = "Search on current file",
      function()
        require("spectre").open_file_search { select_word = true }
      end,
    },
    {
      "<leader>sw",
      mode = { "n", "v" },
      desc = "Search current word",
      function()
        require("spectre").open_visual { select_word = true }
      end,
    },
    {
      "K",
      mode = { "n", "v" },
      desc = "Search current word",
      function()
        require("spectre").open_visual { select_word = true }
      end,
    },
  },
  opts = {
    live_update = true,
  },
}
