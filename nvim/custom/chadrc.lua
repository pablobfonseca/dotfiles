---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  lsp_semantic_tokens = true,
  extended_integrations = { "lspsaga", "trouble", "hop" },

  statusline = {
    theme = "vscode_colored",
  },

  nvdash = {
    load_on_startup = true,
    header = {
      "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
    },
    buttons = {
      { "  Find File", "C-p", "Telescope find_files" },
      { "󰈚  Recent Files", "<leader> rf", "Telescope oldfiles" },
      { "󰈭  Find Word", "<leader>fa", "Telescope live_grep" },
      { "  Themes", "<leader>th", "Telescope themes" },
      { "  Mappings", "<leader>ch", "NvCheatsheet" },
    },
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
