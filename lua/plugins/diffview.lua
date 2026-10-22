-- Neovim has one set of diff highlight groups shared by both windows, so a
-- deleted character and an added character land on the same `DiffText` group --
-- gruvbox paints both bright yellow. Diffview does tell us which side of the
-- layout each window is (`ctx.symbol`), so we can point those groups at
-- side-specific colors with a window-local `winhl` and get red for what left and
-- green for what arrived. The colors themselves live in plugins/gruvbox.lua.
local function side_winhl(winid, symbol)
    -- `b` is always the new state: the right-hand buffer in a 2-way diff, and
    -- the working copy in the merge tool. Everything else is a version we're
    -- diffing against, so it gets the "removed" treatment.
    local side = symbol == "b" and "New" or "Old"

    local ours = {
        DiffAdd = "DiffviewDiff" .. side .. "Full",
        DiffChange = "DiffviewDiff" .. side .. "Line",
        DiffText = "DiffviewDiff" .. side .. "Text",
        DiffTextAdd = "DiffviewDiff" .. side .. "Only",
        DiffDelete = "DiffviewDiffFiller",
    }

    -- Keep whatever else is already in `winhl` -- diffview has set its own diff
    -- mappings by now, and dropbar keeps a long list of its own in here too.
    local merged = {}
    local current = vim.api.nvim_get_option_value("winhl", { win = winid })
    for entry in vim.gsplit(current, ",", { trimempty = true }) do
        local from = entry:match("^([^:]+):")
        if from and not ours[from] then
            merged[#merged + 1] = entry
        end
    end
    for from, to in pairs(ours) do
        merged[#merged + 1] = from .. ":" .. to
    end

    return table.concat(merged, ",")
end

-- Coming back to a diffview tab re-shows the current file, which resets
-- `foldlevel` and closes every fold you had opened. So snapshot the folds and
-- view of each diff window on the way out, and put them back once diffview has
-- re-shown the buffer. Each snapshot remembers its buffer, so a different file in
-- the same window still gets diffview's fresh folding.
--
-- The restore has to wait until every window in the tab is back: setting
-- `foldlevel` in one scrollbound diff window copies it to the others, so the
-- right side being re-shown would refold a left side we'd already restored.
-- (The restore itself unbinds them, see restore_tab_folds.)
-- Shape: saved_folds[tabpage][winid] = { bufnr, closed, view, entered }.
local saved_folds = {}

local function save_folds(winid)
    return vim.api.nvim_win_call(winid, function()
        local closed, lnum, last = {}, 1, vim.fn.line("$")
        while lnum <= last do
            if vim.fn.foldclosed(lnum) ~= -1 then
                closed[#closed + 1] = lnum
                lnum = vim.fn.foldclosedend(lnum) + 1
            else
                lnum = lnum + 1
            end
        end
        return { closed = closed, view = vim.fn.winsaveview() }
    end)
end

local function restore_folds(winid, state)
    vim.api.nvim_win_call(winid, function()
        vim.cmd("silent! %foldopen!")
        for _, lnum in ipairs(state.closed) do
            vim.cmd(("silent! %dfoldclose"):format(lnum))
        end
        vim.fn.winrestview(state.view)
    end)
end

local function restore_tab_folds(tabpage)
    local group = saved_folds[tabpage]
    if not group then
        return
    end
    for _, state in pairs(group) do
        if not state.entered then
            return
        end
    end
    saved_folds[tabpage] = nil

    local wins = {}
    for winid, state in pairs(group) do
        if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == state.bufnr then
            wins[winid] = vim.wo[winid].scrollbind
        end
    end
    -- Fold commands in a scrollbound diff window are mirrored into the others,
    -- and that mirroring recomputes their folds, closing any we just opened.
    -- Unbind while restoring so each window ends up with exactly its own state.
    for winid in pairs(wins) do
        vim.wo[winid].scrollbind = false
    end
    for winid in pairs(wins) do
        restore_folds(winid, group[winid])
    end
    for winid, scrollbind in pairs(wins) do
        vim.wo[winid].scrollbind = scrollbind
    end
end

return {
    -- Maintained fork of sindrets/diffview.nvim; adds a Jujutsu adapter.
    "dlyongemallo/diffview-plus.nvim",
    version = "*",
    lazy = false,
    init = function()
        -- `:DiffviewOpen <rev>` diffs <rev> against the working copy. This is
        -- the `jj show <rev>` view instead: the changes <rev> itself made.
        -- Anything after the rev (`-- paths`, flags) is passed through.
        vim.api.nvim_create_user_command("DiffviewShow", function(cmd)
            local rev = cmd.fargs[1]
            if not rev or vim.startswith(rev, "-") then
                -- No rev means the working copy; plain `:DiffviewOpen` keeps
                -- that side live instead of pinning it to a snapshot.
                vim.cmd("DiffviewOpen " .. cmd.args)
                return
            end
            local rest = table.concat(vim.list_slice(cmd.fargs, 2), " ")
            vim.cmd(("DiffviewOpen %s-..%s %s"):format(rev, rev, rest))
        end, { nargs = "*", desc = "Diffview the changes a single revision made" })
    end,
    keys = {
        -- `--no-merges` is git-only; the jj adapter ignores it.
        { "<leader>gh", "<cmd>:DiffviewFileHistory % --no-merges<cr>", desc = "Diffview File History" },
    },
    opts = {
        -- Colocated repos have both .jj and .git; detect jj first.
        preferred_adapter = "jj",
        hooks = {
            -- Fires after diffview has applied its own winopts, so this wins.
            diff_buf_win_enter = function(bufnr, winid, ctx)
                vim.api.nvim_set_option_value("winhl", side_winhl(winid, ctx.symbol), { win = winid })

                local tabpage = vim.api.nvim_win_get_tabpage(winid)
                local group = saved_folds[tabpage]
                local state = group and group[winid]
                if state then
                    if state.bufnr == bufnr then
                        state.entered = true
                    else
                        -- A different file now; let diffview fold it fresh.
                        group[winid] = nil
                    end
                    vim.schedule(function()
                        restore_tab_folds(tabpage)
                    end)
                end
            end,
            view_leave = function(view)
                local layout = view.cur_layout
                if not layout then
                    return
                end
                local group = {}
                for _, win in ipairs(layout.windows) do
                    local bufnr = win.file and win.file.bufnr
                    if win:is_valid() and bufnr and vim.api.nvim_win_get_buf(win.id) == bufnr then
                        local state = save_folds(win.id)
                        state.bufnr = bufnr
                        group[win.id] = state
                    end
                end
                saved_folds[view.tabpage] = group
            end,
            view_closed = function(view)
                saved_folds[view.tabpage] = nil
            end,
        },
    },
}
