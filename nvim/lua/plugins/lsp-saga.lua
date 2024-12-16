return {
  "glepnir/lspsaga.nvim",
  event = "LspAttach",
  keys = {
    { "<leader>lf", mode = "n", desc = "[L]spsaga [F]inder", "<cmd>Lspsaga finder<cr>" },
    -- { "<leader>lca", mode = "n", desc = "[L]spsaga [C]ode [A]ction", "<cmd>Lspsaga code_action<cr>" },
    { "<leader>lpd", mode = "n", desc = "[L]spsaga [P]eek [D]efinition", "<cmd>Lspsaga peek_definition<cr>" },
    -- { "gd",          mode = "n", desc = "[L]spsaga [G]oto [D]efinition",   "<cmd>Lspsaga goto_definition<cr>" },
    { "<leader>od", mode = "n", desc = "[L]spsaga Show Line Diagnostics", "<cmd>Lspsaga show_line_diagnostics<cr>" },
    {
      "<leader>ob",
      mode = "n",
      desc = "[L]spsaga Show Buffer Diagnostics",
      "<cmd>Lspsaga show_buf_diagnostics<cr>",
    },
    -- { "H", mode = "n", desc = "[L]spsaga Hover Doc", "<cmd>Lspsaga hover_doc<cr>" },
    { "<leader>lr", mode = "n", desc = "[L]spsaga [R]ename", "<cmd>Lspsaga rename<cr>" },
    { "[d", mode = "n", desc = "Go to previous diagnostic message", "<cmd>Lspsaga diagnostic_jump_prev<cr>" },
    { "]d", mode = "n", desc = "Go to next diagnostic message", "<cmd>Lspsaga diagnostic_jump_next<cr>" },
  },
  opts = {},
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    --Please make sure you install markdown and markdown_inline parser
    { "nvim-treesitter/nvim-treesitter" },
  },
}
