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

local keymap = vim.keymap.set
local opts = {noremap = true, silent = true}

-- Add keymap to trigger toggle term
keymap("n", "<leader>tt", ":ToggleTerm<cr>", opts)

function _G.set_terminal_keymaps_options()
    local opts = {buffer = 0}
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
    vim.keymap.set("t", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
    vim.keymap.set("t", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
    vim.keymap.set("t", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)

    keymap("t", "<leader>tt", "<cmd>ToggleTerm<cr>", opts)

    vim.opt.number = true -- Show line numbers
    vim.opt.relativenumber = true -- Show line numbers relative to current line
end

-- Have the aformentioned mappings only for toggleterm rather than terminal
-- mode in general
vim.cmd("autocmd! TermEnter term://*toggleterm#* lua set_terminal_keymaps_options()")
