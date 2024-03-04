return {
  "Mofiqul/dracula.nvim",
  priority = 1000, -- make sure this loads before any other plugins
  opts = {
    transparent_bg = true,
  },
  config = function()
    vim.cmd.colorscheme "dracula"

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
