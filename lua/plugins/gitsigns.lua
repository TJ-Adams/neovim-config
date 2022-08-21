local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
    return
end

gitsigns.setup()

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>cp", "<cmd>Gitsigns preview_hunk<cr>", opts)
keymap("n", "<leader>cs", "<cmd>Gitsigns stage_hunk<cr>", opts)
keymap("n", "<leader>cu", "<cmd>Gitsigns reset_hunk<cr>", opts)
keymap("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", opts)
keymap("n", "]c", "<cmd>Gitsigns next_hunk<cr>", opts)
