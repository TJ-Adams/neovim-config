vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show line numbers relative to current line
vim.opt.wrap = false -- Don't wrap text

vim.opt.clipboard = "unnamedplus" -- Allows global clipboard usage

vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 1 -- Give me 1 line of context above and below when scrolling
vim.opt.termguicolors = true -- More color options. Better looking

vim.opt.listchars = { space = "·", tab = ">-" } -- Assign whitespace colors
vim.opt.list = true -- Turn on whitespace visualization
vim.opt.mouse = "a" -- Allow Mouse Support

vim.opt.scrollback = 25000 -- See further back into terminal output

vim.opt.wildmode = "" -- Disable native cmdline completion (will use blink instead)
vim.opt.wildmenu = false

vim.opt.conceallevel = 2 -- Hide text with the "conceal" attribute

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Make indents 4 spaces

-- Set ignorecase and smartcase so command will autocomplete even if
-- I don't have their cases correct
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Assumes nvr is installed
-- Needed to open another instance of vim inside vim for lazygit
vim.fn.setenv("GITEDITOR", "nvr -cc split --remote-wait +'set bufhidden=wipe'")

-- Folds with syntax highlighting
vim.opt.foldtext = ""
vim.opt.fillchars = "fold: "

-- Don't default to folding everything
vim.opt.foldenable = false
vim.opt.foldlevelstart = 99

vim.o.foldmethod = "expr"

-- Default to treesitter folding
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- https://vi.stackexchange.com/questions/37863/limit-the-amount-of-oldfiles-in-vim-and-neovim
vim.opt.shada = "!,'200,<50,s10,h"  -- Up to 200 files in oldfiles

-- All cursor to move where there's no text present
vim.opt.virtualedit = "all"
