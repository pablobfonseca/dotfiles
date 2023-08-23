local M = {}

M.neodev = {
  override = function(_, library)
    library.enabled = true
    library.plugins = true
  end,
  lspconfig = true,
  pathStrict = true,
}

M.treesitter = {
  matchup = {
    enable = true,
  },
  ensure_installed = {
    "c",
    "css",
    "go",
    "html",
    "http",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "org",
    "ruby",
    "tsx",
    "typescript",
    "vim",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "org" },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "tailwindcss",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- ruby stuff
    "solargraph",

    -- elm stuff
    "elm-format",
    "elm-language-server",

    -- python stuff
    "pyright",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.copilot = {
  suggestion = {
    auto_trigger = true,
  },
}

M.cmp = {
  mapping = {
    ["<CR>"] = require("cmp").mapping.confirm {
      behavior = require("cmp").ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = "nvim_lsp", group_index = 2 },
    { name = "copilot", group_index = 2 },
    { name = "luasnip", group_index = 2 },
    { name = "buffer", group_index = 2 },
    { name = "nvim_lua", group_index = 2 },
    { name = "path", group_index = 2 },
    { name = "cmdline", group_index = 2 },
    { name = "orgmode", group_index = 2 },
  },
}

M.rest = {
  -- Open request results in a horizontal split
  result_split_horizontal = false,
  -- Keep the http file buffer above|left when split horizontal|vertical
  result_split_in_place = false,
  -- Skip SSL verification, useful for unknown certificates
  skip_ssl_verification = false,
  -- Encode URL before making request
  encode_url = true,
  -- Highlight request on run
  highlight = {
    enabled = true,
    timeout = 150,
  },
  result = {
    -- toggle showing URL, HTTP info, headers at top the of result window
    show_url = true,
    -- show the generated curl command in case you want to launch
    -- the same request via the terminal (can be verbose)
    show_curl_command = false,
    show_http_info = true,
    show_headers = true,
    -- executables or functions for formatting response body [optional]
    -- set them to false if you want to disable them
    formatters = {
      json = "jq",
      html = function(body)
        return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
      end,
    },
  },
  -- Jump to request line on run
  jump_to_request = false,
  env_file = ".env",
  custom_dynamic_variables = {},
  yank_dry_run = true,
}

M.spectre = {
  live_update = true,
}

M.telescope = {
  extensions_list = { "themes", "terms", "projects", "file_browser" },
  pickers = {
    find_file = {
      hidden = true,
    },
  },
}

return M
