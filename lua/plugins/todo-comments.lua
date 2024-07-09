local status_ok, todo = pcall(require, "todo-comments")
if not status_ok then
    return
end

todo.setup({
    signs = false,
    highlight = {
        multiline = false, -- enable multine todo comments
        before = "", -- "fg" or "bg" or empty
        keyword = nil, -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = nil, -- "fg" or "bg" or empty
        comments_only = true, -- uses treesitter to match keywords in comments only
        exclude = {}, -- list of file types to exclude highlighting
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>xt", "<cmd>TodoTrouble<cr>", opts)
