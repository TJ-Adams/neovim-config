vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show line numbers relative to current line
vim.opt.wrap = false -- Don't wrap text

vim.opt.clipboard = "unnamedplus" -- Allows global clipboard usage

vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 8 -- Give me >=8 lines of context above and below when scrolling
vim.opt.termguicolors = true -- More color options. Better looking

vim.opt.listchars = {space = "·", tab = ">-"} -- Assing whitespace colors
vim.opt.list = true -- Turn on whitespace visualization
vim.opt.mouse = "a" -- Allow Mouse Support

-- Assumes nvr is installed
-- Needed to open another instance of vim inside vim for lazygit
vim.fn.setenv("GITEDITOR", "nvr -cc split --remote-wait +'set bufhidden=wipe'")