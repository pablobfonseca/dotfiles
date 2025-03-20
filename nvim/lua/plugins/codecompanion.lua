return {
  "olimorris/codecompanion.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
  },
  keys = {
    { "<leader>Cc", mode = "n", desc = "Open Codecompanion chat", "<cmd>CodeCompanionChat Toggle<cr>" },
    { "<leader>CA", mode = { "n", "v" }, desc = "Open Codecompanion actions", "<cmd>CodeCompanionActions<cr>" },
    { "<leader>Ci", mode = { "n", "v" }, desc = "Open Codecompanion inline", ":CodeCompanion " },
  },
  opts = {
    adapters = {
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          schema = {
            model = {
              default = "qwen2.5-coder:latest",
            },
          },
        })
      end,
    },
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "ollama",
      },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
  },
  init = function()
    require("custom.codecompanion.plugins.figet-spinner"):init()
  end,
}
