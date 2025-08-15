return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>F",
      mode = "n",
      desc = "Open Grug Search",
      function()
        require("grug-far").open()
      end,
    },
    {
      "<space>Gs",
      mode = "n",
      desc = "[Grug]: Search current word under cursor",
      function()
        require("grug-far").open { prefills = { search = vim.fn.expand "<cword>" } }
      end,
    },
  },
  config = function()
    require("grug-far").setup {
      -- options, see Configuration section below
      -- there are no required options atm
      -- engine = 'ripgrep' is default, but 'astgrep' can be specified
    }
  end,
}
