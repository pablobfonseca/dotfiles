local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
}

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<C-c>dr",
        desc = "Run debugger",
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
        "<leader>b",
        desc = "Toggle breakpoint",
        mode = "n",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<Leader>dl",
        desc = "Debug log point",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
        end,
      },
    },
    config = function()
      local dap = require "dap"
      require("telescope").load_extension "dap"

      for _, language in ipairs(js_based_languages) do
        -- Debug single nodejs files
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs process (make sure to add --inspect when you run the process)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URl: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          -- Divider for the launch.json derived configs
          {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
          },
        }
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap, dapui = require "dap", require "dapui"
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
    dependencies = { "rcarriga/nvim-dap-ui" },
    opts = {
      enabled = true,
    },
  },
  { "nvim-telescope/telescope-dap.nvim" },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      delve = {
        path = vim.fn.stdpath "data" .. "/mason/bin/" .. "dlv",
      },
    },
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      opts = {
        debugger_path = vim.fn.stdpath "data" .. "/mason/bin/" .. "js-debug-adapter",
        adapters = { "pwa-node", "pwa-chrome" },
      },
    },
  },
}
