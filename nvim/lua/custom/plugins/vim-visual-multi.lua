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
      "<M-l>",
      mode = "n",
      desc = "Create cursor right",
      "<Plug>(VM-Select-l)",
    },
    {
      "<M-h>",
      mode = "n",
      desc = "Create cursor left",
      "<Plug>(VM-Select-h)",
    },
    {
      "<M-k>",
      mode = "n",
      desc = "Create cursor up",
      "<Plug>(VM-Add-Cursor-Up)",
    },
  },
}
