local focus_disabled_opts = {
    autoresize = {
        enable = false,
        minwidth = 25, -- Force minimum width for the unfocused window
        minheight = 2, -- Force minimum height for the unfocused window
    },
    ui = {
        cursorline = false, -- Display a cursorline in the focussed window only
        signcolumn = false, -- Display signcolumn in the focussed window only
    },
}

local focus_enabled_opts = {
    autoresize = {
        enable = true,
        minwidth = 25, -- Force minimum width for the unfocused window
        minheight = 2, -- Force minimum height for the unfocused window
    },
    ui = {
        cursorline = false, -- Display a cursorline in the focussed window only
        signcolumn = false, -- Display signcolumn in the focussed window only
    },
}

-- Keep terminal windows out of the automatic re-equalising.
--
-- In equalise mode focus.nvim runs `wincmd =` on every WinEnter. When the
-- space can't be split evenly (e.g. two vertical splits in an even number of
-- columns), `wincmd =` hands the spare cell to the *current* window, so every
-- window switch moves one column/row between windows. A terminal window that
-- changes size resizes its PTY, and the program inside gets SIGWINCH. TUIs
-- that respond by erasing scrollback (CSI 3 J) and re-printing history make
-- Neovim delete the terminal buffer's lines from the top. Any window whose
-- cursor isn't on the last line then gets its cursor and topline snapped to
-- line 1. Leaving a terminal in terminal mode leaves the cursor on the
-- program's prompt, usually a few lines above the bottom, so a <C-l> out of
-- an AI CLI showed its scrollback jumping to the very top.
--
-- Fix: give terminal windows 'winfixwidth'/'winfixheight' while focus.nvim
-- equalises, so the other windows absorb the slack. <leader>foe still
-- balances everything, terminals included, once, when asked.
local function equalise_keeping_terminals(equalise)
    return function(...)
        local pinned = {}
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
                pinned[win] = { vim.wo[win].winfixwidth, vim.wo[win].winfixheight }
                vim.wo[win].winfixwidth = true
                vim.wo[win].winfixheight = true
            end
        end
        local ok, err = pcall(equalise, ...)
        for win, fix in pairs(pinned) do
            if vim.api.nvim_win_is_valid(win) then
                vim.wo[win].winfixwidth, vim.wo[win].winfixheight = fix[1], fix[2]
            end
        end
        if not ok then
            error(err, 0)
        end
    end
end

return {
    "nvim-focus/focus.nvim",
    opts = focus_disabled_opts,
    config = function(_, opts)
        require("focus").setup(opts)
        local resizer = require("focus.modules.resizer")
        resizer.equalise = equalise_keeping_terminals(resizer.equalise)
    end,
    keys = {
        {
            "<leader>foe",
            function()
                -- Set the goal first: setup() resizes with the current goal,
                -- which would otherwise briefly maximise after <leader>fom.
                require("focus.modules.resizer").goal = "equalise"
                require("focus").setup(focus_enabled_opts)
                -- Plain `wincmd =` so terminals get balanced too (see above).
                vim.cmd("wincmd =")
            end,
            desc = "Equalize Splits",
        },
        {
            "<leader>fom",
            function()
                require("focus.modules.resizer").goal = "maximise"
                require("focus").setup(focus_enabled_opts)
                require("focus").focus_maximise()
            end,
            desc = "Maximize Current Split",
        },
    },
}
