local function set_custom_highlights()
  local set_hl = vim.api.nvim_set_hl

  set_hl(0, "NormalFloat", { link = "Normal" })
  set_hl(0, "FloatBorder", { link = "Comment" }) -- soft border color
  set_hl(0, "Pmenu", { link = "NormalFloat" })
  set_hl(0, "PmenuSel", { link = "Visual" })
  set_hl(0, "PmenuSbar", { bg = "#3a3a3a" })
  set_hl(0, "PmenuThumb", { bg = "#888888" })

  set_hl(0, "LspReferenceText", { link = "Visual" })
  set_hl(0, "LspReferenceRead", { link = "Visual" })
  set_hl(0, "LspReferenceWrite", { link = "Visual" })

  set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "Red" })
  set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "Yellow" })
  set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "Blue" })
  set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "Grey" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_custom_highlights,
})

vim.diagnostic.config {
  underline = true,
  virtual_text = {
    spacing = 2,
    prefix = "●",
    -- Only show most severe diagnostic per line
    severity = { min = vim.diagnostic.severity.HINT },
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    max_width = 80,
    max_height = 20,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.INFO] = "ℹ",
      [vim.diagnostic.severity.HINT] = "💡",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
}
