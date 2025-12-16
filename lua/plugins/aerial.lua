vim.keymap.set("n", "<leader>ah", "<cmd>AerialToggle! left<cr>", { desc = "Aerial Outline Left", silent = true })
vim.keymap.set("n", "<leader>al", "<cmd>AerialToggle! right<cr>", { desc = "Aerial Outline Right", silent = true })
vim.keymap.set("n", "<leader>an", "<cmd>AerialNavToggle<cr>", { desc = "Aerial Navigation", silent = true })

return {
    {
        "stevearc/aerial.nvim",
        -- Prioritize lsp, fallback to treesitter
        opts = {
            backends = { "lsp", "treesitter" },
            nav = {
                -- Make 'q' quit instead of C-c
                keymaps = {
                    ["q"] = "actions.close",
                },
            },
            highlight_mode = "last",
        },
    },
}
