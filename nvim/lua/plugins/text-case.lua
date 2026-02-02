return {
  "johmsalas/text-case.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    { "ga.", "<cmd>TextCaseOpenTelescope<cr>", mode = { "n", "x" }, desc = "Telescope Text Case" },
  },
  opts = {},
  config = function(_, opts)
    require("textcase").setup(opts)
    pcall(require("telescope").load_extension, "textcase")
  end,
}
