return {
  "samharju/yeet.nvim",
  dependencies = {
    "stevearc/dressing.nvim",
  },
  version = "*",
  cmd = "Yeet",
  keys = {
    {
      "<leader>rr",
      mode = "n",
      desc = "Yeet run",
      "<cmd>Yeet<cr>",
    },
    {
      "<C-x>xs",
      mode = "n",
      desc = "Yeet select target",
      function()
        require("yeet").select_target()
      end,
    },
    {
      "<C-x>xl",
      mode = "n",
      desc = "Yeet list",
      function()
        require("yeet").list_cmd()
      end,
    },
    {
      "<C-x>xv",
      mode = { "n", "v" },
      desc = "Yeet visual selection",
      function()
        require("yeet").execute_selection { clear_before_yeet = false }
      end,
    },
  },
  opts = {
    use_cache_file = false,
  },
}
