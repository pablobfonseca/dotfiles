local U = {}

local function _file_search(prompt_tile, cwd)
  local telescope = require "telescope.builtin"

  local opts = {
    prompt_tile = prompt_tile,
    cwd = cwd,
  }

  telescope.find_files(opts)
end

U.models_search = function()
  _file_search("Upscope models", "~/code/upscope/app/app/models")
end

U.controllers_search = function()
  _file_search("Upscope controllers", "~/code/upscope/app/app/controllers")
end

U.specs_search = function()
  _file_search("Upscope tests", "~/code/upscope/app/spec")
end

return U
