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
  endwise = {
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
    "norg",
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
    "prettierd",
    "tailwindcss-language-server",
    "fixjson",
    "js-debug-adapter",

    -- elm stuff
    "elm-format",
    "elm-language-server",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- ruby stuff
    "solargraph",
    "rubocop",

    -- elm stuff
    "elm-format",
    "elm-language-server",

    -- python stuff
    "pyright",
    "flake8",

    -- go stuff
    "gopls",
    "goimports",
    "delve",

    -- haskell
    "haskell-language-server",

    -- writting stuff
    "write-good",
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
  -- mapping = require("cmp").mapping.preset.insert {
  --   ["<CR>"] = require("cmp").mapping.confirm {
  --     select = true,
  --   },
  -- },
  sources = {
    { name = "nvim_lsp", group_index = 2 },
    { name = "copilot", group_index = 2 },
    { name = "luasnip", group_index = 2 },
    { name = "buffer", group_index = 2 },
    { name = "nvim_lua", group_index = 2 },
    { name = "path", group_index = 2 },
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
  extensions_list = { "themes", "terms", "project", "file_browser" },
  pickers = {
    find_file = {
      hidden = true,
    },
  },
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
  },
}

M.telescope_project = {
  extensions = {
    project = {
      base_dirs = {
        "~/code",
        { "~/.dotfiles/" },
      },
      theme = "dropdown",
      order_by = "asc",
      search_by = "title",
      on_project_selected = function(prompt_bufnr)
        require("telescope._extensions.project.actions").find_project_files(prompt_bufnr, true)
      end,
    },
  },
}

M.dapgo = {
  dap_configurations = {
    {
      name = "Debug Upscope CLI",
      type = "go",
      request = "launch",
      mode = "debug",
      preLaunchTask = "go build .",
      program = "${workspaceRoot}/upscope",
      cwd = "${workspaceRoot}",
    },
  },
}

M.dap = {
  library = {
    plugins = {
      { "nvim-dap-ui", types = true },
    },
  },
}

M.dap_vscode_js = {
  plugin = true,
  debugger_path = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter",
  debugger_cmd = { "js-debug-adapter" },
  adapters = {
    "chrome",
    "pwa-node",
    "pwa-chrome",
    "pwa-msedge",
    "node-terminal",
    "pwa-extensionHost",
    "node",
    "chrome",
  },
}

M.neorg = {
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.integrations.telescope"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/Dropbox/notes",
          dotfiles = "~/.dotfiles",
        },
      },
    },
  },
}

return M
