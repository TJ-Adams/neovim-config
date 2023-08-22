-- Shorten functions
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable arrow keys in normal mode
keymap("n", "<down>", "<NOP>", opts)
keymap("n", "<up>", "<NOP>", opts)
keymap("n", "<left>", "<NOP>", opts)
keymap("n", "<right>", "<NOP>", opts)

-- Close Buffer
keymap("n", "<leader>bb", ":bp <BAR> bd #<CR>", opts)

-- Source Config
keymap("n", "<leader>sv", ":source $MYVIMRC<CR>", opts)

-- Prevent jumping to next match on highlight
keymap("n", "*", ":keepjumps normal! mi*`i<CR>", opts)

-- Keymap for creating a terminal buffer and naming it
keymap("n", "<leader>tn", "<cmd>term<cr>:file ", opts)
keymap("t", "<esc>", [[<C-\><C-n>]], opts)

-- Yank file paths
keymap("n", "<leader>ya", "<cmd>let @+ = expand('%:p')<cr>", opts) -- absolute file path
keymap("n", "<leader>yr", "<cmd>let @+ = expand('%')<cr>", opts) -- relative file path
