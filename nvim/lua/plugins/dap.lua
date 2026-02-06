return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    {
      "<C-c>dr",
      function()
        require("dap").continue()
      end,
      desc = "Run debugger / Continue",
    },
    {
      "<C-c>ds",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<C-c>do",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },
    {
      "<C-c>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Step out",
    },
    {
      "<C-c>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<C-c>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input "[DAP] Condition >")
      end,
      desc = "Toggle conditional breakpoint",
    },
    {
      "<C-c>dl",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input "[DAP] Log point message >")
      end,
      desc = "Debug log point",
    },
    {
      "<C-c>de",
      function()
        require("dapui").eval()
      end,
      mode = { "n", "v" },
      desc = "[dap] Eval",
    },
    {
      "<C-c>dE",
      function()
        require("dapui").eval(vim.fn.input "[DAP] Expression >")
      end,
      mode = { "n", "v" },
      desc = "[dap] Eval expression",
    },
    {
      "<C-c>dh",
      function()
        require("dap.ui.widgets").hover()
      end,
      mode = { "n", "v" },
      desc = "[dap] Hover",
    },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    require("dap-go").setup {
      delve = {
        path = vim.fn.resolve(vim.fn.stdpath "data" .. "/mason/bin/dlv"),
      },
      dap_configurations = {
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
    }

    dap.set_log_level "TRACE"
    dapui.setup {}

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

    require("nvim-dap-virtual-text").setup {
      enabled = true,
    }

    require "custom.dap"
  end,
}
