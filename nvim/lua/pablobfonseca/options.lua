local o = vim.opt

-- Basic settings
o.number = true -- Line numbers
o.relativenumber = true -- Relative numbers
o.cursorline = true -- Highlight the current line
o.wrap = true --  wrap lines
o.linebreak = true -- break lines
o.scrolloff = 10 -- Keep 10 lines above/below cursor
o.scroll = 7 -- 7 lines scroll
o.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Format options
o.formatoptions = o.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

-- Indentation
o.tabstop = 2 -- Tab width
o.shiftwidth = 2 -- Indent width
o.softtabstop = 2 -- Soft tab stops
o.expandtab = true -- Use spaces instead of tabs
o.smartindent = true -- Smart auto-indenting
o.autoindent = true -- Copy indent from current line

-- Search settings
o.ignorecase = true -- Case insensitive search
o.smartcase = true -- Case sensitive if uppercase in search
o.hlsearch = false -- Don't highlight search results
o.incsearch = true -- Show matches as you type
o.grepprg = "rg --vimgrep --smart-case --hidden --glob '!.git/'"
o.grepformat = "%f:%l:%c:%m"

-- Tabs
o.showtabline = 1 -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
o.tabline = "" -- Use default tabline (empty string uses built-in)

-- Visual settings
o.termguicolors = true -- Enable 24-but colors
o.signcolumn = "yes" -- Always show sign column
o.colorcolumn = "0" -- Do not show column
o.showmatch = true -- Highlight matching brackets
o.matchtime = 2 -- How long to show matching bracket
o.cmdheight = 1 -- Command line height
o.completeopt = { "menu", "menuone", "noselect" }
o.shortmess:append "c"
o.showmode = false -- Don't show mode in command line
o.pumheight = 10 -- Popup menu height
o.pumblend = 10 -- Popup menu transparency
o.winblend = 0 -- Floating window transparency
o.conceallevel = 0 -- Don't hide markup
o.concealcursor = "" -- Don't hide cursor line markup
o.lazyredraw = true -- Don't redraw during macros
o.synmaxcol = 300 -- Syntax highlight limit
o.shortmess:append "sI" -- Disable neovim intro
o.inccommand = "split" -- shows the effects of substitution

-- File handling
o.backup = false -- Dont' create backup files
o.writebackup = false -- Don't create backup before writing
o.swapfile = false -- Don't create swap files
o.undofile = true -- Persistent undo
o.undodir = os.getenv "HOME" .. "/.local/share/nvim/undodir" -- Undo directory
o.updatetime = 300 -- Faster completion
o.timeoutlen = 500 -- Key timeout duration
o.ttimeoutlen = 0 -- Key code timeout
o.autoread = true -- Auto reload files changed outside vim
o.autowrite = false -- Don't auto save
-- o.isfname:append "@-@" -- add hyfen to filename

-- Behaviour settings
o.hidden = true -- Allow hidden buffers
o.errorbells = false -- No error bells
o.backspace = "indent,eol,start" -- Better backspace behavior
o.autochdir = false -- Don't auto change directory
o.path:append "**" -- include subdirectories in search
o.selection = "exclusive" -- Selection behavior
o.mouse = "" -- Disable mouse
o.clipboard:append "unnamedplus" -- Use system clipboard
o.modifiable = true -- Allow buffer modifications
o.encoding = "UTF-8" -- Set encoding
-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
o.shada = { "'10", "<0", "s10", "h" } -- shared data options
vim.g.editorconfig = true -- respect editorconfig files
o.more = false
-- disable arrow keys
--local arrow_keys = { "<up>", "<left>", "<down>", "<right>" }
--for _, key in ipairs(arrow_keys) do
--  vim.keymap.set("n", key, function()
--    vim.notify("Use hjkl Brav!", vim.log.levels.ERROR)
--  end, {
--    noremap = true,
--    silent = true,
--  })
--end

-- Cursor settings
o.guicursor =
  "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding settings
o.foldmethod = "expr" -- Use expression for folding
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
o.foldlevel = 99 -- Start with all folds open

-- Split behavior
o.splitbelow = true -- Horizontal splits go below
o.splitright = true -- Vertical splits go right

-- Command-line completions
o.wildmenu = true
o.wildmode = "longest:full,full"
o.wildignore:append "**/.git/**,**/node_modules/**,**/dist/**,**/build/**"

-- Better diff options
o.diffopt:append "linematch:60"

-- Performance improvements
o.redrawtime = 10000
o.maxmempattern = 20000

-- Create undo directory if it doesn't exist
local undodir = os.getenv "HOME" .. "/.local/share/nvim/undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
