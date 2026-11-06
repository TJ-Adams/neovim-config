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

-- The commit log panel shows `jj log` output, and we ask jj for its colors
-- (`--color always`) so it looks like `jj show` in a terminal. The panel is a
-- plain buffer, though, so turn the ANSI SGR escapes into highlights: strip
-- them from each line and remember which byte ranges they colored.
--
-- Palette colors (jj's defaults are `38;5;N` with N < 16) resolve through
-- `g:terminal_color_N`, the same palette `:terminal` uses, so they follow the
-- colorscheme. The xterm defaults below only cover a colorscheme that doesn't
-- set them.
local xterm_palette = {
    [0] = "#000000", "#cd0000", "#00cd00", "#cdcd00", "#0000ee", "#cd00cd", "#00cdcd", "#e5e5e5",
    "#7f7f7f", "#ff0000", "#00ff00", "#ffff00", "#5c5cff", "#ff00ff", "#00ffff", "#ffffff",
}

local function palette_color(n)
    if n < 16 then
        return vim.g["terminal_color_" .. n] or xterm_palette[n]
    elseif n < 232 then -- 6x6x6 color cube
        local levels = { [0] = 0, 95, 135, 175, 215, 255 }
        n = n - 16
        return ("#%02x%02x%02x"):format(levels[math.floor(n / 36)], levels[math.floor(n / 6) % 6], levels[n % 6])
    end
    local grey = 8 + (n - 232) * 10 -- grayscale ramp
    return ("#%02x%02x%02x"):format(grey, grey, grey)
end

-- Apply one SGR sequence's parameters to `style` ({ fg, bg, bold, italic,
-- underline }); `fg`/`bg` are hex strings.
local function apply_sgr(style, params)
    local codes = vim.tbl_map(tonumber, vim.split(params == "" and "0" or params, ";", { plain = true }))
    local i = 1
    while i <= #codes do
        local c = codes[i]
        if c == 0 then
            for k in pairs(style) do
                style[k] = nil
            end
        elseif c == 1 then
            style.bold = true
        elseif c == 3 then
            style.italic = true
        elseif c == 4 then
            style.underline = true
        elseif c == 22 then
            style.bold = nil
        elseif c == 23 then
            style.italic = nil
        elseif c == 24 then
            style.underline = nil
        elseif c == 38 or c == 48 then
            local key = c == 38 and "fg" or "bg"
            if codes[i + 1] == 5 and codes[i + 2] then
                style[key] = palette_color(codes[i + 2])
                i = i + 2
            elseif codes[i + 1] == 2 and codes[i + 4] then
                style[key] = ("#%02x%02x%02x"):format(codes[i + 2], codes[i + 3], codes[i + 4])
                i = i + 4
            end
        elseif c == 39 then
            style.fg = nil
        elseif c == 49 then
            style.bg = nil
        elseif c and c >= 30 and c <= 37 then
            style.fg = palette_color(c - 30)
        elseif c and c >= 90 and c <= 97 then
            style.fg = palette_color(c - 90 + 8)
        elseif c and c >= 40 and c <= 47 then
            style.bg = palette_color(c - 40)
        elseif c and c >= 100 and c <= 107 then
            style.bg = palette_color(c - 100 + 8)
        end
        i = i + 1
    end
end

-- A highlight group for `style`, (re)defined on each use so it tracks the
-- current colorscheme.
local function style_group(style)
    if not next(style) then
        return nil
    end
    local name = ("DiffviewAnsi_%s_%s_%s%s%s"):format(
        (style.fg or "none"):gsub("#", ""),
        (style.bg or "none"):gsub("#", ""),
        style.bold and "b" or "",
        style.italic and "i" or "",
        style.underline and "u" or ""
    )
    vim.api.nvim_set_hl(0, name, vim.deepcopy(style))
    return name
end

-- Strip the escapes from `lines` (in place) and return highlights as
-- { group, line_idx (0-based), first, last } byte ranges. Styles carry over
-- line breaks, like in a terminal.
local function ansi_to_highlights(lines)
    local hls, style = {}, {}
    for idx, line in ipairs(lines) do
        local text, pos = {}, 1
        local col = 0
        while true do
            local s, e, params = line:find("\27%[([%d;]*)m", pos)
            local chunk = line:sub(pos, (s or 0) - 1)
            local group = style_group(style)
            if group and #chunk > 0 then
                hls[#hls + 1] = { group, idx - 1, col, col + #chunk }
            end
            text[#text + 1] = chunk
            col = col + #chunk
            if not s then
                break
            end
            apply_sgr(style, params)
            pos = e + 1
        end
        lines[idx] = table.concat(text)
    end
    return hls
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
    config = function(_, opts)
        require("diffview").setup(opts)

        -- The commit log panel (`L`) runs a plain `jj log`, so it uses the
        -- default log template (`builtin_log_compact`), which only prints the
        -- description's first line. Use `jj show -s`'s layout instead: the
        -- detailed header (Commit ID, Author, ...), the whole description,
        -- and the changed files. The summary is part of the template rather
        -- than `-s` so a blank line can follow it, keeping the commits of a
        -- range apart.
        local template = 'builtin_log_detailed ++ self.diff().summary() ++ "\\n"'
        local JjAdapter = require("diffview.vcs.adapters.jj").JjAdapter
        local get_log_args = JjAdapter.get_log_args
        function JjAdapter:get_log_args(args, paths)
            local out = get_log_args(self, args, paths)
            -- Right after `--no-graph`, so it stays ahead of any `-- paths`.
            local at = (vim.list_contains(out, "--no-graph") and vim.fn.index(out, "--no-graph") + 1 or #out) + 1
            table.insert(out, at, "-T")
            table.insert(out, at + 1, template)
            -- Colors too; the panel turns them into highlights (see below).
            table.insert(out, at + 2, "--color=always")
            return out
        end

        -- Render the colored log: plain text in the buffer, with the ANSI
        -- colors as highlights. Output without escapes (git) is left as is.
        local CommitLogPanel = require("diffview.ui.panels.commit_log_panel").CommitLogPanel
        local render = CommitLogPanel.render
        function CommitLogPanel:render()
            render(self)
            local lines = self.render_data.lines
            if not lines or not vim.iter(lines):any(function(l)
                return l:find("\27[", 1, true) ~= nil
            end) then
                return
            end
            for _, hl in ipairs(ansi_to_highlights(lines)) do
                self.render_data:add_hl(hl[1], hl[2], hl[3], hl[4])
            end
        end
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
