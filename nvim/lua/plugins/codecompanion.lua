return {
  "olimorris/codecompanion.nvim",
  enable = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
    -- {
    --   "echasnovski/mini.diff", -- Inline and better diff over the default
    --   config = function()
    --     local diff = require "mini.diff"
    --     diff.setup {
    --       -- Disabled by default
    --       source = diff.gen_source.none(),
    --     }
    --   end,
    -- },
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
            num_ctx = {
              default = 20000,
            },
            model = {
              default = "deepseek-coder:6.7b:Q4_K_M",
            },
          },
        })
      end,
    },
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "anthropic",
        tools = {
          ["mcp"] = {
            -- callin it in a function would prevent mcphub from being loaded before it's needed
            callback = function()
              return "mcphub.extensions.codecompanion"
            end,
            description = "Call tools and resources from the MCP Servers",
            opts = {
              requires_approval = true,
            },
          },
        },
      },
      inline = {
        adapter = "ollama",
      },
      display = {
        diff = {
          provider = "mini_diff",
        },
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
