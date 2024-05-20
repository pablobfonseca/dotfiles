return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
          delve = {
            path = vim.fn.resolve(vim.fn.stdpath "data" .. "/mason/bin/dlv"),
          },
        },
      },
      {
        "pablobfonseca/nvim-dap-ui",
        branch = "fix-deprecations",
        keys = {
          {
            "<C-c>de",
            desc = "Debugger eval",
            mode = { "n", "v" },
            function()
              require("dapui").eval()
            end,
          },
          {
            "<C-c>dE",
            desc = "Debugger eval Expression",
            mode = { "n", "v" },
            function()
              require("dapui").eval(vim.fn.input "[DAP] Expression >")
            end,
          },
        },
        config = function()
          local dap, dapui = require "dap", require "dapui"

          dapui.setup()

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
      { "pablobfonseca/nvim-nio", branch = "fix-deprecations" },
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
    end,
  },
  { "nvim-telescope/telescope-dap.nvim" },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
    },
    config = function()
      require("dap-vscode-js").setup {
        debugger_path = vim.fn.resolve(vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"),
        adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup()
    end,
  },
}
