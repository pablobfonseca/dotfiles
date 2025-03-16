return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          schema = {
            model = {
              default = "deepseek-coder:6.7b",
            },
          },
        })
      end,
    },
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "ollama",
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
}
