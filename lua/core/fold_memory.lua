-- Remember which folds were open or closed when a buffer leaves a window, and
-- put them back when it returns (`:bnext`, H/L, `<C-^>`, ...).
--
-- Neovim only keeps fold state across buffer switches for `foldmethod=manual`;
-- with expr/treesitter/lsp folding the folds are rebuilt from `foldlevel` and
-- everything you opened closes again. This keeps the state in memory only, per
-- window and buffer, so it doesn't survive a restart.
--
-- Diff windows are left alone: their folds are mirrored between the two sides,
-- and diffview handles its own (see plugins/diffview.lua).

local group = vim.api.nvim_create_augroup("FoldMemory", { clear = true })

-- saved[winid][bufnr] = { closed = { lnum, ... }, view = winsaveview() }
local saved = {}

local function tracked(winid, bufnr)
    return vim.bo[bufnr].buftype == "" and not vim.wo[winid].diff
end

local function closed_folds()
    local closed, lnum, last = {}, 1, vim.fn.line "$"
    while lnum <= last do
        if vim.fn.foldclosed(lnum) ~= -1 then
            closed[#closed + 1] = lnum
            lnum = vim.fn.foldclosedend(lnum) + 1
        else
            lnum = lnum + 1
        end
    end
    return closed
end

vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function(args)
        local winid = vim.api.nvim_get_current_win()
        saved[winid] = saved[winid] or {}
        -- With folding off there's nothing to remember; let Neovim do its usual
        -- thing when the buffer comes back.
        if not tracked(winid, args.buf) or not vim.wo[winid].foldenable then
            saved[winid][args.buf] = nil
            return
        end
        saved[winid][args.buf] = { closed = closed_folds(), view = vim.fn.winsaveview() }
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
        local winid = vim.api.nvim_get_current_win()
        local state = saved[winid] and saved[winid][args.buf]
        if not state then
            return
        end
        -- Deferred so the buffer's fold expression (treesitter, lsp) has been
        -- set up before we try to open and close its folds.
        vim.schedule(function()
            if not vim.api.nvim_win_is_valid(winid) or vim.api.nvim_win_get_buf(winid) ~= args.buf then
                return
            end
            if not tracked(winid, args.buf) or not vim.wo[winid].foldenable then
                return
            end
            vim.api.nvim_win_call(winid, function()
                vim.cmd "silent! %foldopen!"
                for _, lnum in ipairs(state.closed) do
                    vim.cmd(("silent! %dfoldclose"):format(lnum))
                end
                if vim.fn.line "." == state.view.lnum then
                    vim.fn.winrestview(state.view)
                else
                    -- Arrived somewhere else (a jump, quickfix, `+42`): keep
                    -- that spot and make sure it isn't hidden in a fold.
                    vim.cmd "normal! zv"
                end
            end)
        end)
    end,
})

vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(args)
        saved[tonumber(args.match)] = nil
    end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
        for _, bufs in pairs(saved) do
            bufs[args.buf] = nil
        end
    end,
})
