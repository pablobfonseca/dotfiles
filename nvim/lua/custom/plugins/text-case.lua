return {
  "johmsalas/text-case.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = {
    "Subs",
    "TextCaseOpenTelescope",
  },
  keys = {
    "ga", -- Default invocation prefix
    { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
  },
  config = function()
    require("textcase").setup {}
    require("telescope").load_extension "textcase"
  end,
}
