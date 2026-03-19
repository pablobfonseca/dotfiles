return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  cmd = "Telescope",
  keys = {
    { "<space>t", "<cmd>Telescope<cr>", desc = "Open Telescope" },
    {
      "<C-s>",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "Fuzzy finder on current buffer",
    },
    {
      "<C-p>",
      function()
        require("telescope.builtin").find_files {
          find_command = { "rg", "--ignore", "--hidden", "--files", "--glob", "!.git" },
        }
      end,
      desc = "Find file",
    },
    { "<leader>f", function() require("custom.telescope.multi-ripgrep")() end, desc = "Live Grep" },
    {
      "<C-x>b",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Telescope buffers",
    },
    {
      "gs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Git status",
    },
    {
      "<C-x>k",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Find keymaps",
    },
    {
      "<C-x>h",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help page",
    },
    {
      "<leader>ds",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      desc = "Search document symbols",
    },
    {
      "<leader>rp",
      function()
        require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config", prompt_title = " neovim" }
      end,
      desc = "Search Neovim files",
    },
    {
      "<leader>df",
      function()
        require("telescope.builtin").find_files {
          prompt_title = " dotfiles",
          cwd = "~/.dotfiles",
        }
      end,
      desc = "Find dotfiles",
    },
    {
      "<leader>sr",
      function()
        require("custom.telescope.multi-ripgrep") {
          prompt_title = "Search for nvim config",
          cwd = "~/.config/nvim",
        }
      end,
      desc = "Search for nvim config",
    },
    {
      "<leader>K",
      function()
        require("telescope.builtin").grep_string {}
      end,
      mode = { "n", "v" },
      desc = "Search current word",
    },
    {
      "<space>fa",
      function()
        require("telescope.builtin").find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
      end,
      desc = "Find in lazy plugins",
    },
  },
  opts = function()
    local actions = require "telescope.actions"
    return {
      defaults = {
        mappings = {
          i = {
            ["<C-\\>"] = actions.to_fuzzy_refine,
          },
        },
        prompt_prefix = "  ",
        selection_caret = "  ",
        entry_prefix = "  ",
        sorting_strategy = "descending",
        file_ignore_patterns = { "node_modules" },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
