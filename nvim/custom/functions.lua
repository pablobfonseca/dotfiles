local M = {}

local function _config_search(prompt_tile, cwd)
  local telescope = require "telescope.builtin"

  local opts = {
    prompt_title = " " .. prompt_tile,
    cwd = cwd,
    require("telescope.themes").get_dropdown {
      winblend = 10,
    },
  }

  telescope.live_grep(opts)
end

local function _find_file(prompt_tile, cwd)
  local telescope = require "telescope.builtin"

  local opts = {
    prompt_title = " " .. prompt_tile,
    cwd = cwd,
  }

  telescope.find_files(opts)
end

M.config_search = function()
  _config_search("nvim config", "~/.config/nvim")
end

M.dotfiles_search = function()
  _config_search("dotfiles", "~/.dotfiles")
end

M.config_files = function()
  _find_file("nvim files", "~/.config/nvim/lua/custom")
end

M.find_dotfiles = function()
  _find_file("dotfiles", "~/.dotfiles")
end

return M
