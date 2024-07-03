return {
  "mistweaverco/kulala.nvim",
  keys = {
    {
      "<leader>rm",
      mode = "n",
      desc = "Open rest mode",
      "<cmd>RestMode<cr>",
    },
    {
      "<C-c><C-c>",
      mode = "n",
      desc = "Run request",
      function()
        require("kulala").run()
      end,
    },
  },
}
