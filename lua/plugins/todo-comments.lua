vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<cr>")

return {
    "folke/todo-comments.nvim",
    opts = {
        signs = false,
        gui_style = {
            fg = "None", -- The gui style to use for the fg highlight group.
            bg = "None", -- The gui style to use for the bg highlight group.
        },
        keywords = {
            TODO = { color = "todo" },
            NOTE = { color = "note" },
            HACK = { color = "warn" },
            WARN = { color = "warn" },
            BUG  = { color = "warn" },
        },

        highlight = {
            multiline = false, -- enable multine todo comments
            before = "", -- "fg" or "bg" or empty
            keyword = "fg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
            after = "", -- "fg" or "bg" or empty
            comments_only = true, -- uses treesitter to match keywords in comments only
            exclude = {}, -- list of file types to exclude highlighting
        },
        colors = {
            todo = { "@text.todo" },
            note = { "@text.reference"},
            warn= { "@text.warning"},
        },
    },
}
