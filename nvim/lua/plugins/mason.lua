return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "delve",
        "js-debug-adapter",
        "fixjson",
        "goimports",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "prettier",
        "prettierd",
        "stylua",
        "tailwindcss-language-server",
        "typescript-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Auto-install ensure_installed packages
      local mr = require "mason-registry"
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {},
  },
}
