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

local set = vim.keymap.set

set("n", "<space>t", "<cmd>Telescope<cr>", { desc = "Open Telescope" })
set("n", "<C-s>", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_ivy {
    winblend = 10,
    previewer = false,
  })
end, { desc = "Fuzzy finder on current buffer" })
set("n", "<C-p>", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>", { desc = "Find file" })
set("n", "<space>p", "<cmd>Telescope git_files<cr>", { desc = "Find git files" })
set("n", "<leader>f", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
set("n", "<C-x>b", "<cmd>Telescope buffers<cr>", { desc = "Telescope buffers" })
set("n", "gs", function()
  require("telescope.builtin").git_status()
end, { desc = "Git status" })
set("n", "bs", function()
  require("telescope.builtin").git_branches()
end, { desc = "Git branches" })
set("n", "<C-x>k", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
set("n", "<C-x>h", "<cmd> Telescope help_tags <CR>", { desc = "Help page" })
set("n", "<M-x>", "<cmd>Telescope commands theme=ivy<cr>", { desc = "Telescope commands" })
set("n", "<leader>ds", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Search document symbols" })
set("n", "<leader>ws", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Workspace document symbols" })
set("n", "<leader>rp", function()
  require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config", prompt_title = " neovim" }
end, { desc = "Search [N]eovim files" })
set("n", "<leader>df", function()
  require("telescope.builtin").find_files {
    prompt_title = " dotfiles",
    cwd = "~/.dotfiles",
  }
end, { desc = "Find dotfiles" })
set("n", "<leader>sr", function()
  require("telescope.builtin").live_grep {
    prompt_title = "Search for nvim config",
    cwd = "~/.dotfiles",
  }
end, { desc = "Search for nvim config" })
set({ "n", "v" }, "K", function()
  require("telescope.builtin").grep_string { cwd = require("telescope.utils").buffer_dir() }
end, { desc = "Search current word" })
