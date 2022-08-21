-- Don't add any mappings
vim.g.context_add_mappings = 0
vim.g.context_add_autocmds = 1

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<leader>ct", "<cmd>ContextToggle<cr>", opts)
