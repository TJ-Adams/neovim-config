return {
    "echasnovski/mini.surround",
    opts = {
        -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        highlight_duration = 2000,

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            add = "<space>sa", -- Add surrounding in Normal and Visual modes
            delete = "<space>sd", -- Delete surrounding
            find = "", -- Find surrounding (to the right)
            find_left = "", -- Find surrounding (to the left)
            highlight = "", -- Highlight surrounding
            replace = "<space>sc", -- Replace surrounding
            update_n_lines = "", -- Update `n_lines`
        },

        search_method = "cover_or_nearest",
    },
}
