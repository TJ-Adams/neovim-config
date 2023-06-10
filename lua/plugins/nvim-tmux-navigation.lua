-- Shorten functions
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
keymap("n", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
keymap("n", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
keymap("n", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)

keymap("t", "<C-j>", "<esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
keymap("t", "<C-k>", "<esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
keymap("t", "<C-h>", "<esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
keymap("t", "<C-l>", "<esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)
