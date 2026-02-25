vim.opt.number = true      -- line numbers bar
vim.opt.wrap = false       -- long line wrapping
vim.opt.expandtab = true   -- expand tab to spaces
vim.opt.autoindent = true  -- copy indent from current line when starting new one
vim.opt.copyindent = true
vim.opt.breakindent = true -- for wrapped lines
vim.opt.smartindent = true -- C style indenting
--show not-visible characters
vim.opt.list = true
vim.opt.listchars = "eol:$,tab:>-,trail:~,extends:>,precedes:<"

vim.opt.tabstop = 4    -- tab spaces
vim.opt.shiftwidth = 4 -- shift spaces

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

--search settings
vim.opt.smartcase = true  -- while searching case insensitive if not explicit capitals
vim.opt.ignorecase = true -- to make previous option works correctly

--scrolling
vim.opt.scrolloff = 5 -- amount of visible line on top and bottom during scrolling

--appereance
vim.opt.cursorline = true -- light current line
vim.opt.cursorlineopt = "both"
vim.opt.cursorcolumn = true
vim.opt.background = "dark"
vim.opt.signcolumn = 'yes'   -- reserve space for plugins icons
vim.opt.termguicolors = true -- possibly more available colores
vim.opt.showcmd = true
-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
vim.opt.swapfile = false

vim.opt.undofile = true -- saving undo history

--big files folding
--vim.opt.foldmethod = "indent"
--vim.opt.foldlevel = 4

vim.opt.updatetime = 500 -- faster than default

vim.opt.pumheight = 5    -- popups menu size (for example from autocmp)
