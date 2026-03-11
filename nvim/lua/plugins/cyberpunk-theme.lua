return {
  "pablobfonseca/cyberpunk-theme",
  priority = 1000,
  lazy = false,
  config = function()
    require("cyberpunk").setup {
      style = "storm",
      lsp = { ui = true },
    }
    vim.cmd "colorscheme cyberpunk"
  end,
}
