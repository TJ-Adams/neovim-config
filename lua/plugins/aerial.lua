local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
    return
end

aerial.setup({})


local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>a", "<cmd>AerialToggle!<cr>", opts)

keymap("n", "{", "<cmd>AerialPrev<CR>", opts)
keymap("n", "}", "<cmd>AerialNext<CR>", opts)

keymap("n", "[[", "<cmd>AerialPrevUp<CR>", opts)
keymap("n", "]]", "<cmd>AerialNextUp<CR>", opts)
