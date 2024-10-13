return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
    },
    config = function(_, opts)
      require "custom.mason"
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require "custom.mason-lsp"
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "delve",
        "js-debug-adapter",
      },
    },
  },
}
