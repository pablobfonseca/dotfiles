return {
  "numToStr/Comment.nvim",
  lazy = false,
  keys = {
    {
      "cml",
      mode = "n",
      desc = "Toggle comment",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
    },
    {
      "<M-/>",
      mode = "n",
      desc = "Toggle comment",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
    },
    {
      "<M-/>",
      mode = "v",
      desc = "Toggle comment",
      "<cmd>normal gc<cr>",
    },
  },
  opts = {},
}
