local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

toggleterm.setup()

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- Add 4 quickly accessible terminals
keymap("n", "<leader>tj", ":0 ToggleTerm<cr>", opts)
keymap("n", "<leader>tk", ":1 ToggleTerm<cr>", opts)
keymap("n", "<leader>tl", ":2 ToggleTerm<cr>", opts)
keymap("n", "<leader>t;", ":3 ToggleTerm<cr>", opts)

keymap("n", "<leader>tt", ":ToggleTerm<cr>", opts)

function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
    vim.keymap.set("t", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
    vim.keymap.set("t", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
    vim.keymap.set("t", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)
end

-- Have the aformentioned mappings only for toggleterm rather than terminal
-- mode in general
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
