return {
  "rest-nvim/rest.nvim",
  ft = "http",
  dependencies = { "luarocks.nvim" },
  keys = {
    {
      "<leader>rm",
      mode = "n",
      desc = "Open RestMode",
      "<cmd>RestMode<cr>",
    },
  },
  config = function()
    require("rest-nvim").setup {
      keybinds = {
        {
          "<C-c><C-c>",
          "<cmd>Rest run<cr>",
          "Run request under the cursor",
        },
      },
    }
  end,
}
