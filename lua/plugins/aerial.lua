local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
    return
end

aerial.setup(
    {
        backends = {"lsp", "treesitter"} -- Prioritize lsp, fallback to treesitter
    }
)

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>a", "<cmd>AerialToggle! left<cr>", opts)

keymap("n", "{", "<cmd>AerialPrev<CR>", opts)
keymap("n", "}", "<cmd>AerialNext<CR>", opts)

keymap("n", "[[", "<cmd>lua require('aerial').prev_up()<CR>", opts)
keymap("n", "]]", "<cmd>lua require('aerial').next_up()<CR>", opts)
