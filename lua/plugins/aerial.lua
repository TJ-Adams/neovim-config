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

keymap("n", "<leader>aa", "<cmd>AerialToggle! left<cr>", opts)
keymap("n", "<leader>an", "<cmd>AerialNavToggle<cr>", opts)

keymap("n", "{", "<cmd>AerialPrev<CR>", opts)
keymap("n", "}", "<cmd>AerialNext<CR>", opts)

keymap("n", "[[", "<cmd>lua require('aerial').prev_up()<CR>", opts)
keymap("n", "]]", "<cmd>lua require('aerial').next_up()<CR>", opts)

local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

wk.register(
    {
        a = {
            a = "Toggle Aerial Window",
            n = "Toggle Aerial Navigation",
        },
    },
    {prefix = "<leader>"}
)
