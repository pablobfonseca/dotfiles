return {
  "rest-nvim/rest.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "restmode" },
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
      "<cmd>RestMode<cr>"
    },
  },
}