local status_ok, todo = pcall(require, "todo-comments")
if not status_ok then
    return
end

todo.setup({
    signs = false,
    highlight = {
        override = false,
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>xt", "<cmd>TodoTrouble<cr>", opts)
