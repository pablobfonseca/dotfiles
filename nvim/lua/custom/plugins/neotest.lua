return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-vim-test",
    "vim-test/vim-test",
    { "pablobfonseca/neotest-go", branch = "fix-deprecations" },
    "nvim-neotest/neotest-python",
    "olimorris/neotest-rspec",
  },
  keys = {
    {
      "<leader>Tn",
      mode = "n",
      desc = "Run nearest test",
      function()
        require("neotest").run.run()
      end,
    },
    {
      "<leader>Tf",
      mode = "n",
      desc = "Run current test file",
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
    },
    {
      "<leader>To",
      mode = "n",
      desc = "Test output",
      function()
        require("neotest").output.open { enter = true }
      end,
    },
  },
  config = function()
    local neotest = require "neotest"

    neotest.setup {
      adapters = {
        require "neotest-rspec" {
          rspec_cmd = function()
            return vim
                .iter({
                  "upscope",
                  "app",
                  "test",
                  "-t",
                })
                :flatten()
                :totable()
          end,
          transform_spec_path = function(path)
            print("path: " .. vim.inspect(path))
            local prefix = require("neotest-rspec").root(path)
            print("prefix: " .. vim.inspect(prefix))
            local result = string.sub(path, string.len(prefix) + 2, -1)
            print("result: " .. vim.inspect(result))
            return result
          end,
        },
        require "neotest-python",
        require "neotest-go",
        require "neotest-vim-test" { ignore_filetypes = { "python", "go", "ruby" } },
      },
    }
  end,
}
