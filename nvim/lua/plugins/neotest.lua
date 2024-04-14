return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-vim-test",
    "vim-test/vim-test",
    "nvim-neotest/neotest-go",
    -- "olimorris/neotest-rspec",
  },
  keys = {
    {
      "<c-c>Tn",
      mode = "n",
      desc = "Run nearest test",
      function()
        require("neotest").run.run()
      end,
    },
    {
      "<c-c>Tf",
      mode = "n",
      desc = "Run current test file",
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
    },
    {
      "<c-c>To",
      mode = "n",
      desc = "Test output",
      function()
        require("neotest").output.open { enter = true }
      end,
    },
  },
  config = function()
    local neotest = require "neotest"

    -- vim.api.nvim_exec2(
    --   [[
    --   function! DockerTransform(cmd)
    --     echo cmd
    --     return "upscope api test -t $(tmux display-message -p '#S') " .a:cmd
    --   endfunction
    --   ]],
    --   { output = false }
    -- )

    -- vim.cmd [[ let test#custom_transformations = {"docker": function("DockerTransform")}]]
    -- vim.cmd [[ let test#transformation = "docker"]]
    -- vim.cmd [[ let g:test#basic#start_normal = 1 " If using basic strategy ]]

    neotest.setup {
      adapters = {
        -- require "neotest-rspec" {
        --   rspec_cmd = function()
        --     return vim.tbl_flatten {
        --       "upscope",
        --       "app",
        --       "test",
        --       "-t",
        --     }
        --   end,
        --
        --   transform_spec_path = function(path)
        --     local prefix = require("neotest-rspec").root(path)
        --     return string.sub(path, string.len(prefix) + 2, -1)
        --   end,
        --   results_path = "tmp/rspec.output",
        -- },
        require "neotest-go",
        require "neotest-vim-test" { ignore_filetypes = { "go" } },
      },
    }
  end,
}
