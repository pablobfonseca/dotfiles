local telescope = require "telescope"
local builtin = require "telescope.builtin"
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-\\>"] = actions.to_fuzzy_refine,
      },
    },
    extensions = {
      file_browser = {
        hijack_netrw = true,
        display_stat = false,
      },
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
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

pcall(telescope.load_extension "fzf")
pcall(telescope.load_extension "file_browser")

local set = vim.keymap.set

set("n", "<space>t", function()
  vim.cmd "Telescope"
end, { desc = "Open Telescope" })
set("n", "<C-s>", function()
  builtin.current_buffer_fuzzy_find()
end, { desc = "Fuzzy finder on current buffer" })
set("n", "<C-p>", function()
  builtin.find_files {
    find_command = { "rg", "--ignore", "--hidden", "--files", "--glob", "!.git" },
  }
end, { desc = "Find file" })
set("n", "<leader>f", require "custom.telescope.multi-ripgrep", { desc = "Live Grep" })
set("n", "<C-x>b", function()
  builtin.buffers()
end, { desc = "Telescope buffers" })
set("n", "gs", function()
  builtin.git_status()
end, { desc = "Git status" })
set("n", "<C-x>k", function()
  builtin.keymaps()
end, { desc = "Find keymaps" })
set("n", "<C-x>h", function()
  builtin.help_tags()
end, { desc = "Help page" })
set("n", "<leader>ds", function()
  builtin.lsp_document_symbols()
end, { desc = "Search document symbols" })
set("n", "<leader>rp", function()
  builtin.find_files { cwd = vim.fn.stdpath "config", prompt_title = " neovim" }
end, { desc = "Search [N]eovim files" })
set("n", "<leader>df", function()
  builtin.find_files {
    prompt_title = " dotfiles",
    cwd = "~/.dotfiles",
  }
end, { desc = "Find dotfiles" })
set("n", "<leader>sr", function()
  require "custom.telescope.multi-ripgrep" {
    prompt_title = "Search for nvim config",
    cwd = "~/.dotfiles",
  }
end, { desc = "Search for nvim config" })
set({ "n", "v" }, "K", function()
  builtin.grep_string {}
end, { desc = "Search current word" })
set("n", "<space>fa", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
end)
