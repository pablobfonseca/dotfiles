return {
  "theprimeagen/harpoon",
  keys = {
    {
      "<C-c>ha",
      mode = "n",
      desc = "Add file to harpoon",
      function()
        require("harpoon.mark").add_file()
      end,
    },
    {
      "<C-c>ht",
      mode = "n",
      desc = "Toggle harpoon",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
    },
    {
      "<C-c>hn",
      mode = "n",
      desc = "Navigate to next file",
      function()
        require("harpoon.ui").nav_next()
      end,
    },
    {
      "<C-c>hp",
      mode = "n",
      desc = "Navigate to previous file",
      function()
        require("harpoon.ui").nav_prev()
      end,
    },
  },
  config = function()
    require("harpoon").setup {}
    require("telescope").load_extension "harpoon"
  end,
}
