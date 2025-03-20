local opt = vim.opt

-- Numbers
opt.number = true
opt.relativenumber = true

-- disable nvim intro
opt.shortmess:append "sI"

-- completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append "c"

-- disable mouse and arrow keys
vim.o.mouse = ""
local arrow_keys = { "<up>", "<left>", "<down>", "<right>" }
for _, key in ipairs(arrow_keys) do
  vim.keymap.set("n", key, function()
    vim.notify("Use hjkl Brav!", vim.log.levels.ERROR)
  end, {
    noremap = true,
    silent = true,
  })
end

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true

opt.fillchars = { eob = " " }
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv "HOME" .. "/.local/share/nvim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.scrolloff = 5
opt.scroll = 7
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 300

opt.colorcolumn = "0"

opt.isfname:append "@-@"

-- Make updates happen faster
opt.updatetime = 50

-- set bell off
opt.belloff = "all"

opt.formatoptions = opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. ":" .. vim.env.PATH

-- change diagnostics signs
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = " ",
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

opt.shada = { "'10", "<0", "s10", "h" }

-- add command abbrev for codecompanion
vim.cmd [[cab cc CodeCompanion]]

-- gets rid of line with white spaces
vim.g.editorconfig = true
