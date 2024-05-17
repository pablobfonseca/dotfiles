return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    {
      "<C-s>",
      mode = "n",
      desc = "Fuzzy finder on current buffer",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_ivy {
          winblend = 10,
          previewer = false,
        })
      end,
    },
    {
      "<C-p>",
      mode = "n",
      desc = "Find file",
      "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>",
    },
    { "<space>p",  mode = "n", desc = "Find git files",    "<cmd>Telescope git_files<cr>" },
    { "<leader>f", mode = "n", desc = "Live Grep",         "<cmd>Telescope live_grep<cr>" },
    { "<C-x>b",    mode = "n", desc = "Telescope buffers", "<cmd>Telescope buffers<cr>" },
    {
      "gs",
      mode = "n",
      desc = "Git status",
      function()
        require("telescope.builtin").git_status()
      end,
    },
    {
      "bs",
      mode = "n",
      desc = "Git branches",
      function()
        require("telescope.builtin").git_branches()
      end,
    },
    { "<C-x>k", mode = "n", desc = "Find keymaps",       "<cmd>Telescope keymaps<cr>" },
    { "<C-x>h", mode = "n", desc = "Help page",          "<cmd> Telescope help_tags <CR>" },
    { "<M-x>",  mode = "n", desc = "Telescope commands", "<cmd>Telescope commands theme=ivy<cr>" },
    {
      "K",
      mode = "n",
      desc = "Search current word",
      function()
        require("telescope.builtin").grep_string()
      end,
    },
    {
      "<leader>ds",
      mode = "n",
      desc = "Search document symbols",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
    },
    {
      "<leader>ws",
      mode = "n",
      desc = "Workspace document symbols",
      function()
        require("telescope.builtin").lsp_workspace_symbols()
      end,
    },
    { "<leader>to", mode = "n", desc = "Browse oldfiles", "<cmd>Telescope oldfiles<cr>" },
    {
      "<leader>rp",
      mode = "n",
      desc = "Search [N]eovim files",
      function()
        require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config", prompt_title = " neovim" }
      end,
    },
    {
      "<leader>df",
      mode = "n",
      desc = "Find dotfiles",
      function()
        require("telescope.builtin").find_files {
          prompt_title = " dotfiles",
          cwd = "~/.dotfiles",
        }
      end,
    },
    {
      "<leader>sr",
      mode = "n",
      desc = "Search for nvim config",
      function()
        require("telescope.builtin").live_grep {
          prompt_title = "Search for nvim config",
          cwd = "~/.dotfiles",
        }
      end,
    },
  },
  config = function()
    local telescope = require "telescope"
    telescope.setup {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        prompt_prefix = "  ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      },
    }

    telescope.load_extension "fzf"
  end,
}
