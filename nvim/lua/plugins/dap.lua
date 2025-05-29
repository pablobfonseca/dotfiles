return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        opts = {
          delve = {
            path = vim.fn.resolve(vim.fn.stdpath "data" .. "/mason/bin/dlv"),
          },
        },
      },
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<C-c>de",
            desc = "[dap] Eval",
            mode = { "n", "v" },
            function()
              require("dapui").eval()
            end,
          },
          {
            "<C-c>dE",
            desc = "[dap] Eval Expression",
            mode = { "n", "v" },
            function()
              require("dapui").eval(vim.fn.input "[DAP] Expression >")
            end,
          },
          {
            "<C-c>dh",
            desc = "[dap] Hover",
            mode = { "n", "v" },
            function()
              require("dap.ui.widgets").hover()
            end,
          },
        },
        config = function()
          local dap, dapui = require "dap", require "dapui"

          -- mappings = {
          --   edit = "e",
          --   expand = { "<CR>", "<2-LeftMouse>" },
          --   open = "o",
          --   remove = "d",
          --   repl = "r",
          --   toggle = "t"
          -- }

          dap.set_log_level "TRACE"

          dapui.setup {
            controls = {
              element = "repl",
              enabled = false,
            },
            floating = {
              max_height = 0.5,
              max_width = 0.5,
              border = "rounded",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.70 },
                  { id = "watches", size = 0.30 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.75 },
                },
                size = 0.35,
                position = "right",
              },
              {
                elements = {
                  { id = "repl", size = 0.50 },
                  { id = "console", size = 0.50 },
                },
                size = 0.30,
                position = "bottom",
              },
            },
          }

          dap.listeners.before.attach.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.launch.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
          end
          dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
        },
      },
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<C-c>dr",
        desc = "Run debugger / Continue",
        mode = "n",
        function()
          require("dap").continue()
        end,
      },
      {
        "<C-c>ds",
        desc = "Step into",
        mode = "n",
        function()
          require("dap").step_into()
        end,
      },
      {
        "<C-c>do",
        desc = "Step over",
        mode = "n",
        function()
          require("dap").step_over()
        end,
      },
      {
        "<C-c>dO",
        desc = "Step out",
        mode = "n",
        function()
          require("dap").step_out()
        end,
      },
      {
        "<C-c>db",
        desc = "Toggle breakpoint",
        mode = "n",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<C-c>dB",
        desc = "Toggle conditional breakpoint",
        function()
          require("dap").set_breakpoint(vim.fn.input "[DAP] Condition >")
        end,
      },
      {
        "<C-c>dl",
        desc = "Debug log point",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input "[DAP] Log point message >")
        end,
      },
    },
    config = function()
      require("telescope").load_extension "dap"

      require "custom.dap"
    end,
  },
  { "nvim-telescope/telescope-dap.nvim" },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      require("dap-python").setup()
    end,
  },
}
