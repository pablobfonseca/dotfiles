---@type vim.lsp.Config
return {
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  init_options = {
    hostInfo = "neovim",
    preferences = {
      -- Balance performance with functionality
      includeCompletionsForModuleExports = true, -- Re-enable for imports
      includeCompletionsForImportStatements = true, -- Re-enable for auto-imports
      includeCompletionsWithSnippetText = false,
      includeAutomaticOptionalChainCompletions = false,
      includeCompletionsWithClassMemberSnippets = true, -- Re-enable for better completions
      includeCompletionsWithObjectLiteralMethodSnippets = false,
      generateReturnInDocTemplate = false,
      includeCompletionsWithInsertText = true,
      -- Performance settings
      allowRenameOfImportPath = false,
      displayPartsForJSDoc = false,
      -- Limit completion items for better performance
      includePackageJsonAutoImports = "off",
    },
    maxTsServerMemory = 4096, -- Limit TypeScript server memory to 4GB
    tsserver = {
      maxTsServerMemory = 4096,
      useSyntaxServer = "auto", -- Use separate syntax server for better performance
      -- Log level (off for better performance)
      logVerbosity = "off",
    },
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = false,
      },
      suggest = {
        completeFunctionCalls = false, -- Reduces completion processing
      },
      surveys = {
        enabled = false,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = false,
      },
      suggest = {
        completeFunctionCalls = false,
      },
    },
    diagnostics = {
      -- Reduce diagnostic computation for better performance
      ignoredCodes = {
        80001, -- File is a CommonJS module
      },
    },
    completions = {
      completeFunctionCalls = false,
    },
  },
}
