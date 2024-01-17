local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "solargraph",
  "pyright",
  "gopls",
  "elmls",
  "emmet_language_server",
  "hls",
  "rust_analyzer",
  "tailwindcss",
  "jsonls",
  "sqls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.jsonls.setup {
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

lspconfig.hls.setup {
  filetypes = { "haskell", "lhaskell", "cabal" },
}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup {
  filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
  },
}

lspconfig.solargraph.setup {
  filetypes = { "ruby", "haml" },
  init_options = {
    solargraph = {
      formatting = true,
    },
  },
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
}
