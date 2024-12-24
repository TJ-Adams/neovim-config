local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
    return
end

aerial.setup({
    -- Prioritize lsp, fallback to treesitter
    backends = { "lsp", "treesitter" },
    nav = {
        -- Make 'q' quit instead of C-c
        keymaps = {
            ["q"] = "actions.close",
        },
    },
    highlight_mode = "last",
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>ah", "<cmd>AerialToggle! left<cr>", opts)
keymap("n", "<leader>al", "<cmd>AerialToggle! right<cr>", opts)
keymap("n", "<leader>an", "<cmd>AerialNavToggle<cr>", opts)

keymap("n", "{", "<cmd>AerialPrev<CR>", opts)
keymap("n", "}", "<cmd>AerialNext<CR>", opts)

keymap("n", "[[", "<cmd>lua require('aerial').prev_up()<CR>", opts)
keymap("n", "]]", "<cmd>lua require('aerial').next_up()<CR>", opts)

local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

