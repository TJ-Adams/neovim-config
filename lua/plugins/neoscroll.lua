local status_ok, neoscroll = pcall(require, "neoscroll")
if not status_ok then
    return
end

neoscroll.setup()

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "gg", "<cmd>lua require'neoscroll'.scroll(-2*vim.api.nvim_buf_line_count(0), true, 1, 'circular')<cr>", opts)
keymap("n", "G", "<cmd>lua require'neoscroll'.scroll(2*vim.api.nvim_buf_line_count(0), true, 1, 'circular')<cr>", opts)

