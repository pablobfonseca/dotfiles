---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<leader>b"] = "",
    ["K"] = "",
    ["H"] = "",
    ["<C-n>"] = "",
    ["gr"] = "",
    ["gd"] = "",
    ["<leader>ca"] = "",
    ["<leader>ra"] = "",
    ["<leader>od"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-x><C-s>"] = { ":w<cr>", "Save file" },
    ["<C-x><C-c>"] = { ":x<cr>", "Save and quit" },
    ["<C-x><C-d>"] = { ":e ~/.dotfiles/config.toml<cr>", "Open dotfiles config" },
    ["<C-s>"] = {
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_ivy {
          winblend = 10,
        })
      end,
      "Fuzzily search in current buffer",
    },
    ["<leader>i"] = { "mmgg=G`m", "Indent the whole file" },
    ["<C-x>1"] = { ":only<cr>", "Keep only the current pane" },
    ["<C-x>2"] = { ":split<cr>", "Split pane horizontally" },
    ["<C-x>3"] = { ":vsplit<cr>", "Split pane vertically" },
    ["<C-x>0"] = { ":q<cr>", "Close pane" },
    ["<M-x>1"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs()
      end,
      "Keep only current buffer",
    },
    ["gp"] = { "`[v`]", "Select last paste in visual mode" },
    ["<leader>fh"] = { "<C-w>t<C-w>K", "Change vertically split to horizontally" },
    ["<leader>fv"] = { "<C-w>t<C-w>H", "Change horizontally split to vertically" },
    ["Y"] = { "y$", "Make Y yank to end of line (like D, or C)" },
    ["<space>e"] = {
      ":e <C-R>=escape(expand('%:p:h'),' ') . '/'<CR>",
      "Edit another file in the same directory as the current file",
    },
    ["<C-x><C-f>"] = {
      ":e <C-R>=escape(expand('%:p:h'),' ') . '/'<CR>",
      "Edit another file in the same directory as the current file",
    },
    ["<space>s"] = {
      ":split <C-R>=escape(expand('%:p:h'), ' ') . '/'<CR>",
      "Split file in the same directory as the current file",
    },
    ["<space>v"] = {
      ":vsplit <C-R>=escape(expand('%:p:h'), ' ') . '/'<CR>",
      "Vertical split file in the same directory as the current file",
    },
    ["<space>r"] = {
      ":r <C-R>=escape(expand('%:p:h'), ' ') . '/'<CR>",
      "Read from file in the same directory as the current file",
    },
    ["<space>t"] = {
      ":tabe <C-R>=escape(expand('%:p:h'), ' ') . '/'<CR>",
      "Open in a tab another file in the same directory as the current file",
    },
    ["<space><space>"] = { ":ccl<cr>", "Close quickfix window" },
    ["<C-e>"] = { "7<C-e>", "Scroll the viewport faster" },
    ["<C-y>"] = { "7<C-y>", "Scroll the viewport faster" },
    ["<leader><space>"] = { ":nohl<cr>", "Clear search highlight" },
    ["<leader>rm"] = { "<cmd>RestMode<cr>", "Open RestMode" },
    ["<leader>sr"] = {
      function()
        require("custom.functions").config_search()
      end,
      "Search for nvim config",
    },
    ["<leader>rp"] = {
      function()
        require("custom.functions").config_files()
      end,
      "Find nvim config files",
    },
    ["<leader>df"] = {
      function()
        require("custom.functions").find_dotfiles()
      end,
      "Find dotfiles",
    },
    ["<leader>um"] = {
      function()
        require("custom.dev.upscope.functions").models_search()
      end,
      "Find Upscope models",
    },
    ["<leader>uc"] = {
      function()
        require("custom.dev.upscope.functions").controllers_search()
      end,
      "Find Upscope controllers",
    },
    ["<leader>us"] = {
      function()
        require("custom.dev.upscope.functions").specs_search()
      end,
      "Find Upscope specs",
    },
  },
  v = {
    ["<C-e>"] = { "7<C-e>", "Scroll the viewport faster" },
    ["<C-y>"] = { "7<C-y>", "Scroll the viewport faster" },
  },
}

M.telescope = {
  plugin = true,
  n = {
    ["<C-p>"] = { "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>", "Find files" },
    ["<leader>f"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    ["<C-x>b"] = { "<cmd>Telescope buffers theme=ivy<cr>", "Find Buffers" },
    ["gs"] = {
      function()
        require("telescope.builtin").git_status(require("telescope.themes").get_ivy {
          winblend = 10,
        })
      end,
      "Git status",
    },
    ["bs"] = {
      function()
        require("telescope.builtin").git_branches(require("telescope.themes").get_ivy {
          winblend = 10,
        })
      end,
      "Git branches",
    },
    ["<C-x>t"] = { "<cmd>Telescope tags<cr>", "Find tags" },
    ["<C-x>k"] = { "<cmd>Telescope keymaps<cr>", "Find keymaps" },
    ["<C-x>h"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["K"] = {
      function()
        require("telescope.builtin").grep_string(require("telescope.themes").get_ivy {
          winblend = 10,
        })
      end,
      "Search current word",
    },
    ["<leader>ds"] = {
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      "Search document symbols",
    },
    ["<leader>ws"] = {
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end,
      "Search workspace symbols",
    },
    ["<leader>fb"] = {
      ":Telescope file_browser theme=ivy<cr>",
      "Telescope file browser",
    },
  },
}

M.telescope_project = {
  plugin = true,
  n = {
    ["<leader>cd"] = {
      function()
        require("telescope").extensions.project.project { display_type = "full" }
      end,
      "Telescope project",
    },
  },
}

M.comment = {
  plugin = true,
  n = {
    ["cml"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
    ["<M-/>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
  },
  v = {
    ["<M-/>"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,
  n = {
    ["<leader>lgr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
    },
    ["<leader>od"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Open LSP Diagnostics",
    },
  },
}

M.gitsigns = {
  plugin = true,
  n = {
    ["<leader>b"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },
  },
}

M.nvimtree = {
  plugin = true,
  n = {
    ["<C-d>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  },
}

M.spectre = {
  plugin = true,
  n = {
    ["<leader>S"] = {
      function()
        require("spectre").open()
      end,
      "Open Spectre",
    },
    ["<leader>sw"] = {
      function()
        require("spectre").open_visual { select_word = true }
      end,
      "Search current word",
    },
  },
  v = {
    ["<leader>sw"] = {
      function()
        require("spectre").open_visual()
      end,
      "Search current selected word",
    },
  },
}

M.hop = {
  plugin = true,
  n = {
    ["<space>hw"] = { "<cmd>HopWord<cr>", "[H]op [W]ord" },
    ["<space>hl"] = { "<cmd>HopLine<cr>", "[H]op [L]ine" },
    ["<space>hc"] = { "<cmd>HopChar<cr>", "[H]op [C]har" },
  },
}

M.nvim_window = {
  plugin = true,
  n = {
    ["<M-o>"] = {
      function()
        require("nvim-window").pick()
      end,
      "Pick a window",
    },
  },
}

M.lsp_saga = {
  plugin = true,
  n = {
    ["<leader>llf"] = { "<cmd>Lspsaga finder<cr>", "Lspsaga Finder" },
    ["<leader>ca"] = { "<cmd>Lspsaga code_action<cr>", "Lspsaga Code Action" },
    ["<leader>lpd"] = { "<cmd>Lspsaga peek_definition<cr>", "Lspsaga Peek Definition" },
    ["gd"] = { "<cmd>Lspsaga goto_definition<cr>", "Lspsaga Goto Definition" },
    ["<leader>od"] = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Lspsaga Show Line Diagnostics" },
    ["<leader>lsb"] = { "<cmd>Lspsaga show_buf_diagnostics<cr>", "Lspsaga Show Buffer Diagnostics" },
    ["H"] = { "<cmd>Lspsaga hover_doc<cr>", "Lspsaga Hover Doc" },
    ["<leader>ra"] = { "<cmd>Lspsaga rename<cr>", "Lspsaga Rename" },
  },
}

M.trouble = {
  plugin = true,
  n = {
    ["<leader>tt"] = { "<cmd>TroubleToggle<cr>", "Trouble Toggle" },
  },
}

M.rest = {
  plugin = true,
  n = {
    ["<C-c><C-c>"] = {
      function()
        require("rest-nvim").run()
      end,
      "Rest Run",
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<space>d"] = {
      function()
        require("dap").continue()
      end,
      "DAP - Start debugging",
    },
    ["<space>b"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "DAP - Toggle breakpoint",
    },
  },
}

M.neorg = {
  plugin = true,
  n = {
    ["<C-x>w"] = { "<cmd>Telescope neorg switch_workspace<cr>", "Change Neorg Workspace" },
  },
}

-- more keybinds!

return M
