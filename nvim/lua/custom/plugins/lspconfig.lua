return {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    require "custom.lsp"
  end,
}
