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

return {
    "nvim-focus/focus.nvim",
    opts = focus_disabled_opts,
    keys = {
        {
            "<leader>foe",
            function()
                require("focus").setup(focus_enabled_opts)
                require("focus").focus_equalise()
            end,
            desc = "Equalize Splits",
        },
        {
            "<leader>fom",
            function()
                require("focus").setup(focus_enabled_opts)
                require("focus").focus_maximise()
            end,
            desc = "Maximize Current Split",
        },
    },
}
