return {
  "glepnir/lspsaga.nvim",
  event = "LspAttach",
  keys = {
    { "<leader>llf", mode = "n", desc = "Lspsaga Finder",                    "<cmd>Lspsaga finder<cr>" },
    { "<leader>ca",  mode = "n", desc = "Lspsaga Code Action",               "<cmd>Lspsaga code_action<cr>" },
    { "<leader>lpd", mode = "n", desc = "Lspsaga Peek Definition",           "<cmd>Lspsaga peek_definition<cr>" },
    { "gd",          mode = "n", desc = "Lspsaga Goto Definition",           "<cmd>Lspsaga goto_definition<cr>" },
    { "<leader>od",  mode = "n", desc = "Lspsaga Show Line Diagnostics",     "<cmd>Lspsaga show_line_diagnostics<cr>" },
    { "<leader>lsb", mode = "n", desc = "Lspsaga Show Buffer Diagnostics",   "<cmd>Lspsaga show_buf_diagnostics<cr>" },
    { "H",           mode = "n", desc = "Lspsaga Hover Doc",                 "<cmd>Lspsaga hover_doc<cr>" },
    { "<leader>ra",  mode = "n", desc = "Lspsaga Rename",                    "<cmd>Lspsaga rename<cr>" },
    { "[d",          mode = "n", desc = "Go to previous diagnostic message", "<cmd>Lspsaga diagnostic_jump_prev<cr>" },
    { "]d",          mode = "n", desc = "Go to next diagnostic message",     "<cmd>Lspsaga diagnostic_jump_next<cr>" },
  },
  opts = {},
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    --Please make sure you install markdown and markdown_inline parser
    { "nvim-treesitter/nvim-treesitter" },
  },
}
