return {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "folke/neodev.nvim",
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    local lsp_zero = require "lsp-zero"

    require("neodev").setup {
      library = { plugins = { "nvim-dap-ui", "neotest" }, types = true },
    }

    lsp_zero.on_attach(function(client, bufnr)
      lsp_zero.default_keymaps { buffer = bufnr }
      local opts = { buffer = bufnr }

      vim.keymap.set({ "n", "x" }, "<leader>i", function()
        vim.lsp.buf.format {
          async = false,
          timeout_ms = 10000,
        }
      end, opts)
    end)
  end,
}
