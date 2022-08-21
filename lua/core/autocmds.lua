-- Erase white space on saves
vim.cmd([[ autocmd BufWritePre * %s/\s\+$//e ]])

-- Open up help documents in a vertical split instead
-- of horizontal
vim.cmd([[ autocmd! FileType help :wincmd L ]])
