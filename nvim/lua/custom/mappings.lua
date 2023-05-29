---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<leader>b"] = "",
    ["K"] = "",
    ["<C-n>"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-x><C-s>"] = { ":w<cr>", "Save file" },
    ["<C-x><C-c>"] = { ":x<cr>", "Save and quit" },
    ["<C-s>"] = {
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      "Fuzzily search in current buffer",
    },
    ["<C-x>1"] = { ":only<cr>", "Keep only the current pane" },
    ["<C-x>2"] = { ":split<cr>", "Split pane horizontally" },
    ["<C-x>3"] = { ":vsplit<cr>", "Split pane vertically" },
    ["<C-x>0"] = { ":q<cr>", "Close pane" },
    ["gp"] = { "`[v`]", "Select last paste in visual mode" },
    ["<leader>fh"] = { "<C-w>t<C-w>K", "Change vertically split to horizontally" },
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
    ["<leader>sr"] = {
      function()
        require("custom.functions").configSearch()
      end,
      "Search for nvim config",
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
    ["<C-p>"] = { "<cmd>Telescope find_files<cr>" },
    ["<leader>f"] = { "<cmd>Telescope live_grep<cr>" },
    ["<C-x>b"] = { "<cmd>Telescope buffers<cr>" },
    ["gs"] = { "<cmd>Telescope git_status<cr>" },
    ["<C-x>t"] = { "<cmd>Telescope tags<cr>" },
    ["<C-x>k"] = { "<cmd>Telescope keymaps<cr>" },
    ["K"] = {
      function()
        require("telescope.builtin").grep_string()
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
  },
  v = {
    ["K"] = {
      function()
        require("telescope.builtin").grep_string()
      end,
      "Search current word",
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
    ["cm"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,
  n = {
    ["H"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },
    ["gr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
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

-- more keybinds!

return M
