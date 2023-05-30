local M = {}

local function _config_search(prompt_tile, cwd)
  local telescope = require "telescope.builtin"

  local opts = {
    prompt_title = prompt_tile,
    cwd = cwd,
  }

  telescope.live_grep(opts)
end

M.config_search = function()
  _config_search("Search inside nvim config", "~/.config/nvim")
end

M.old_config_search = function()
  _config_search("Search inside old nvim config", "~/.dotfiles/vim")
end

M.config_files = function()
  local telescope = require "telescope.builtin"

  local opts = {
    prompt_title = "Search for nvim files",
    cwd = "~/.config/nvim/lua",
  }

  telescope.find_files(opts)
end

return M
