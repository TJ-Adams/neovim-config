-- Open up help documents in a vertical split instead
-- of horizontal
vim.cmd [[ autocmd! FileType help :wincmd L ]]

-- TODO: Workaround. Either look into or make a pull request so
--       this plugin just shows signs all the time by default
vim.cmd "autocmd BufReadPost * lua require('quicknote').ShowNoteSigns()"
