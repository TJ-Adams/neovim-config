local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

toggleterm.setup(
    {
        persist_mode = true,
        direction = "float",
        auto_scroll = false,
        float_opts = {
            border = "curved",
        }
    }
)

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- Add 4 quickly accessible terminals
keymap("n", "<leader>tj", ":1 ToggleTerm<cr>", opts)
keymap("n", "<leader>tk", ":2 ToggleTerm<cr>", opts)
keymap("n", "<leader>tl", ":3 ToggleTerm<cr>", opts)
keymap("n", "<leader>t;", ":4 ToggleTerm<cr>", opts)

keymap("n", "<leader>tt", ":ToggleTerm<cr>", opts)

-- Allow quick access to terminals in terminal mode as well
keymap("t", "<leader>tj", "<cmd>1 ToggleTerm<cr>", opts)
keymap("t", "<leader>tk", "<cmd>2 ToggleTerm<cr>", opts)
keymap("t", "<leader>tl", "<cmd>3 ToggleTerm<cr>", opts)
keymap("t", "<leader>t;", "<cmd>4 ToggleTerm<cr>", opts)

keymap("t", "<leader>tt", "<cmd>ToggleTerm<cr>", opts)

function _G.set_terminal_keymaps_options()
    local opts = {buffer = 0}
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
    vim.keymap.set("t", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
    vim.keymap.set("t", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
    vim.keymap.set("t", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)

    vim.opt.number = true -- Show line numbers
    vim.opt.relativenumber = true -- Show line numbers relative to current line

end

-- Have the aformentioned mappings only for toggleterm rather than terminal
-- mode in general
vim.cmd("autocmd! TermEnter term://*toggleterm#* lua set_terminal_keymaps_options()")
