local js_based_languages = {
  "typescript",
  "typescriptreact",
  "javascript",
  "javascriptreact",
}

--- Gets a path to a package in the Mason registry
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
local function get_pkg_path(pkg, path)
  pcall(require, "mason")
  local root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  return ret
end

local dap = require "dap"
dap.set_log_level "DEBUG"

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  protocol = "inspector",
  executable = {
    command = "node",
    args = {
      get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
      "${port}",
    },
  },
}

for _, language in ipairs(js_based_languages) do
  dap.configurations[language] = {
    --Debug single nodejs files
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
    -- Debug remote node
    {
      type = "pwa-node",
      request = "attach",
      name = "Node Remote Debug Adapter (Upscope API)",
      address = os.getenv "DOCKERMACHINE_IP",
      remoteHostHeader = os.getenv "DOCKERMACHINE_IP",
      cwd = "${workspaceFolder}",
      continueOnAttach = true,
      remoteRoot = "/upscope_api",
      localRoot = vim.fn.getcwd() .. "/api",
      sourceMaps = true,
      outFiles = { vim.fn.getcwd() .. "/**/*.js" },
      timeout = 5000,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**" },
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
            prompt = "Enter URL: ",
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
      useDataDir = false,
    },
    -- Divider for the launch.json derived configs
    {
      name = "----- ↓ launch.json configs ↓ -----",
      type = "",
      request = "launch",
    },
  }
end

local function reset_dapui_layout()
  local dapui = require "dapui"

  dapui.close()
  dapui.open()
end

vim.api.nvim_create_user_command("DapUIReset", reset_dapui_layout, {
  desc = "Close & re-open DAP-UI to its default layout",
})
