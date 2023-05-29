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

return M
