local telescope = require "telescope"
local lga_actions = require "telescope-live-grep-args.actions"
local builtin = require "telescope.builtin"
local z_utils = require "telescope._extensions.zoxide.utils"

local select_one_or_multi = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
    mappings = {
      i = {
        ["<CR>"] = select_one_or_multi,
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
          },
        },
      },
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      zoxide = {
        prompt_title = "[ Zoxide List ]",
        -- Zoxide list command with score
        list_command = "zoxide query -ls",
        mappings = {
          default = {
            keepinsert = true,
            action = function(selection)
              builtin.find_files { cwd = selection.path, find_command = { "rg", "--files", "--hidden", "-g", "!.git" } }
            end,
          },
          ["<C-s>"] = { action = z_utils.create_basic_command "split" },
          ["<C-v>"] = { action = z_utils.create_basic_command "vsplit" },
          ["<C-e>"] = { action = z_utils.create_basic_command "edit" },
          ["<C-b>"] = {
            keepinsert = true,
            action = function(selection)
              builtin.file_browser { cwd = selection.path }
            end,
          },
          ["<C-f>"] = {
            keepinsert = true,
            action = function(selection)
              builtin.find_files { cwd = selection.path, find_command = { "rg", "--files", "--hidden", "-g", "!.git" } }
            end,
          },
        },
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

telescope.load_extension "fzf"
telescope.load_extension "live_grep_args"
telescope.load_extension "zoxide"
telescope.load_extension "cmdline"

local set = vim.keymap.set

set("n", "<space>t", function()
  vim.cmd "Telescope"
end, { desc = "Open Telescope" })
set("n", "<C-s>", function()
  builtin.current_buffer_fuzzy_find()
end, { desc = "Fuzzy finder on current buffer" })
set("n", "<C-p>", function()
  builtin.find_files {
    find_command = { "rg", "--ignore", "--hidden", "--files" },
  }
end, { desc = "Find file" })
set("n", "<space>p", function()
  builtin.git_files()
end, { desc = "Find git files" })
set("n", "<leader>f", function()
  -- builtin.live_grep()

  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Live Grep" })
set("n", "<C-x>b", function()
  builtin.buffers()
end, { desc = "Telescope buffers" })
set("n", "gs", function()
  builtin.git_status()
end, { desc = "Git status" })
set("n", "bs", function()
  builtin.git_branches()
end, { desc = "Git branches" })
set("n", "<C-x>k", function()
  builtin.keymaps()
end, { desc = "Find keymaps" })
set("n", "<C-x>h", function()
  builtin.help_tags()
end, { desc = "Help page" })
set("n", "<M-x>", ":Telescope cmdline<CR>", { desc = "Telescope commands" })
set("n", "<leader>ds", function()
  builtin.lsp_document_symbols()
end, { desc = "Search document symbols" })
set("n", "<leader>ws", function()
  builtin.lsp_workspace_symbols()
end, { desc = "Workspace document symbols" })
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
  builtin.live_grep {
    prompt_title = "Search for nvim config",
    cwd = "~/.dotfiles",
  }
end, { desc = "Search for nvim config" })
set({ "n", "v" }, "K", function()
  builtin.grep_string {}
end, { desc = "Search current word" })
set("n", "<leader>z", function()
  telescope.extensions.zoxide.list()
end, { desc = "Change current workdir with zoxide" })
