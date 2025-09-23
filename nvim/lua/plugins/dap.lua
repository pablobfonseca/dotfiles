vim.pack.add {
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/leoluz/nvim-dap-go" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
}

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

vim.keymap.set({ "n", "v" }, "<C-c>de", function()
  require("dapui").eval()
end, { desc = "[dap] Eval" })

vim.keymap.set({ "n", "v" }, "<C-c>dE", function()
  require("dapui").eval(vim.fn.input "[DAP] Expression >")
end, { desc = "[dap] Eval expression" })

vim.keymap.set({ "n", "v" }, "<C-c>dh", function()
  require("dap.ui.widgets").hover()
end, { desc = "[dap] Hover" })

local dap, dapui = require "dap", require "dapui"

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

local set = vim.keymap.set

set("n", "<C-c>dr", function()
  require("dap").continue()
end, { desc = "Run debugger / Continue" })

set("n", "<C-c>dr", function()
  require("dap").continue()
end, { desc = "Run debugger / Continue" })
set("n", "<C-c>ds", function()
  require("dap").step_into()
end, { desc = "Step into" })
set("n", "<C-c>do", function()
  require("dap").step_over()
end, { desc = "Step over" })
set("n", "<C-c>dO", function()
  require("dap").step_out()
end, { desc = "Step out" })
set("n", "<C-c>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
set("n", "<C-c>dB", function()
  require("dap").set_breakpoint(vim.fn.input "[DAP] Condition >")
end, { desc = "Toggle conditional breakpoint" })
set("n", "<C-c>dl", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input "[DAP] Log point message >")
end, { desc = "Debug log point" })

require "custom.dap"
