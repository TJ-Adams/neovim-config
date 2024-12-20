local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>gh", "<cmd>:DiffviewFileHistory % --no-merges<cr>", opts)
