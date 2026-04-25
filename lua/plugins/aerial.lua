return {
    {
        "stevearc/aerial.nvim",
        -- Prioritize lsp, fallback to treesitter
        opts = {
            backends = {
                ["_"] = { "lsp", "treesitter" },
                markdown = { "treesitter", "lsp" },
            },
            nav = {
                -- Make 'q' quit instead of C-c
                keymaps = {
                    ["q"] = "actions.close",
                },
            },
            highlight_mode = "last",
        },
        keys = {
            { "<leader>ah", "<cmd>AerialToggle! left<cr>", desc = "Aerial Outline Left" },
            { "<leader>al", "<cmd>AerialToggle! right<cr>", desc = "Aerial Outline Right" },
            { "<leader>an", "<cmd>AerialNavToggle<cr>", desc = "Aerial Navigation" },
        },
    },
}
