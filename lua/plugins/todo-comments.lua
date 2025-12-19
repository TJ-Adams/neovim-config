vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<cr>")

return {
    "folke/todo-comments.nvim",
    opts = {
        signs = false,
        highlight = {
            multiline = false, -- enable multine todo comments
            before = "", -- "fg" or "bg" or empty
            keyword = nil, -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
            after = nil, -- "fg" or "bg" or empty
            comments_only = true, -- uses treesitter to match keywords in comments only
            exclude = {}, -- list of file types to exclude highlighting
        },
    },
}
