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

-- Keymap for creating a terminal buffer and naming it
keymap("n", "<leader>tn", "<cmd>term<cr>:file ", opts)
keymap("t", "<esc>", [[<C-\><C-n>]], opts)

-- Yank file paths
keymap("n", "<leader>ya", "<cmd>let @+ = expand('%:p')<cr>", opts) -- absolute file path
keymap("n", "<leader>yr", "<cmd>let @+ = expand('%')<cr>", opts) -- relative file path

-- Switch Tabs
keymap("n", "[t", "<cmd>tabprevious<cr>", opts)
keymap("n", "]t", "<cmd>tabnext<cr>", opts)

-- Function to search for the visual selection without moving to the next match
local function search_vselection()
    -- Save the current visual selection into a variable
    local start_pos = vim.fn.getpos "."
    local end_pos = vim.fn.getpos "v"

    local search_pattern = vim.fn.getregion(start_pos, end_pos)

    search_pattern = table.concat(search_pattern, "\\n")

    -- Escape special characters. Might not work with '\'
    search_pattern = vim.fn.escape(search_pattern, "/.*$^~[]")

    print(search_pattern)

    -- Search for the pattern without jumping
    vim.fn.setreg("/", search_pattern)
    vim.opt.hls = true
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

keymap("v", "*", function()
    search_vselection()
end)
