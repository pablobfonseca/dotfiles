return {
  "rest-nvim/rest.nvim",
  ft = { "http", "restmode" },
  dependencies = { "luarocks" },
  keys = {
    {
      "<C-c><C-c>",
      mode = "n",
      desc = "Rest Run",
      function()
        require("rest-nvim").run()
      end,
    },
    {
      "<leader>rm",
      mode = "n",
      desc = "Open RestMode",
      "<cmd>RestMode<cr>",
    },
  },
  config = function()
    require("rest-nvim").setup()
  end,
}
