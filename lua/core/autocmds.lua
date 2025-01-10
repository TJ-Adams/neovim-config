-- Open up help documents in a vertical split instead
-- of horizontal
vim.cmd [[ autocmd! FileType help :wincmd L ]]

-- Auto-create parent directories (except for URIs "://").
vim.cmd [[ au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif ]]
