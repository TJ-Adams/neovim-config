vim.g.minimap_auto_start = 1
vim.g.minimap_auto_start_win_enter = 0
vim.g.context_add_auto_commads = 0

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<leader>m", "<cmd>MinimapToggle<cr>", opts)

