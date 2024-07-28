local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
    return
end

gitsigns.setup()

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>cl", "<cmd>Gitsigns toggle_current_line_blame<cr>", opts)
keymap("n", "<leader>co", "<cmd>lua require('gitsigns').blame_line({full=true,})<cr>", opts)
keymap("n", "<leader>cp", "<cmd>Gitsigns preview_hunk<cr>", opts)
keymap("n", "<leader>cs", "<cmd>Gitsigns stage_hunk<cr>", opts)
keymap("n", "<leader>cu", "<cmd>Gitsigns reset_hunk<cr>", opts)
keymap("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", opts)
keymap("n", "]c", "<cmd>Gitsigns next_hunk<cr>", opts)

local function toggle_diffview()
    vim.cmd "Gitsigns toggle_word_diff"
    vim.cmd "Gitsigns toggle_linehl"
    vim.cmd "Gitsigns toggle_deleted"
end

keymap("n", "<leader>dg", function()
    toggle_diffview()
end, opts)
