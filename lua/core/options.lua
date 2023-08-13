vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show line numbers relative to current line
vim.opt.wrap = false -- Don't wrap text

vim.opt.clipboard = "unnamedplus" -- Allows global clipboard usage

vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 8 -- Give me >=8 lines of context above and below when scrolling
vim.opt.termguicolors = true -- More color options. Better looking

vim.opt.listchars = { space = "·", tab = ">-" } -- Assing whitespace colors
vim.opt.list = true -- Turn on whitespace visualization
vim.opt.mouse = "a" -- Allow Mouse Support

vim.opt.scrollback = 25000 -- See further back into terminal output

vim.opt.wildmode = "longest,list,full" -- Change command tab completion to be like terminal
vim.opt.wildmenu = true

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
