local lsp_zero = require "lsp-zero"

require("mason-lspconfig").setup {
  ensure_installed = require "pablobfonseca.config.lsp_servers",
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)
    end,
    harper_ls = function()
      require("lspconfig").harper_ls.setup {
        filetypes = { "markdown", "gitcommit", "NeogitCommitMessage" },
      }
    end,
    jsonls = function()
      require("lspconfig").jsonls.setup {
        settings = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      }
    end,
  },
}
