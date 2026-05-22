-- Open up help documents in a vertical split instead
-- of horizontal
vim.cmd [[ autocmd! FileType help :wincmd L ]]

-- Auto-create parent directories (except for URIs "://").
vim.cmd [[ au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif ]]

-- Reload files changed on disk (e.g. by a formatter or terminal command) when entering a buffer
vim.opt.autoread = true
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("AutoReload", { clear = true }),
    callback = function()
        if vim.bo.buftype == "" then
            vim.cmd("checktime")
        end
    end,
})

-- In the quickfix list, dd removes the entry under the cursor (closes if last)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = vim.api.nvim_create_augroup("QuickfixDelete", { clear = true }),
    callback = function(args)
        vim.keymap.set('n', 'dd', function()
            local line = vim.api.nvim_win_get_cursor(0)[1]
            local qflist = vim.fn.getqflist()
            table.remove(qflist, line)
            if #qflist == 0 then
                vim.fn.setqflist({}, 'r')
                vim.cmd('cclose')
            else
                vim.fn.setqflist(qflist, 'r')
                vim.api.nvim_win_set_cursor(0, { math.min(line, #qflist), 0 })
            end
        end, { buffer = args.buf })
    end,
})

-- When pressing <C-o> from a terminal, skip past other terminal entries
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("TerminalNoJump", { clear = true }),
    callback = function(args)
        vim.keymap.set('n', '<C-o>', function()
            local jumplist, idx = unpack(vim.fn.getjumplist())
            local current_buf = vim.api.nvim_get_current_buf()
            local presses = 0
            local remaining = vim.v.count1
            for i = idx - 1, 0, -1 do
                presses = presses + 1
                local entry = jumplist[i + 1]
                if not (entry and entry.bufnr == current_buf) then
                    remaining = remaining - 1
                    if remaining == 0 then break end
                end
            end
            if presses > 0 then
                vim.cmd('normal! ' .. presses .. '\x0f')
            end
        end, { buffer = args.buf })
    end,
})
