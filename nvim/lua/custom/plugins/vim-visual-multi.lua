return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  keys = {
    {
      "<M-j>",
      mode = "n",
      desc = "Create cursor down",
      "<Plug>(VM-Add-Cursor-Down)",
    },
    {
      "<M-k>",
      mode = "n",
      desc = "Create cursor up",
      "<Plug>(VM-Add-Cursor-Up)",
    },
  },
}
