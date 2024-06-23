local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
    return
end

trouble.setup()

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", opts)
keymap("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)
keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", opts)
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", opts)
