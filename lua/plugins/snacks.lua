vim.keymap.set("n", "<leader>e", function() require("snacks").explorer.reveal() end)

return {
    "folke/snacks.nvim",
    opts = {
        input = {},
        styles = {
            input = {
                relative = "cursor",
            },
        },
        explorer = {
            -- your explorer configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        picker = {
            sources = {
                explorer = {
                    -- your explorer picker configuration comes here
                    -- or leave it empty to use the default settings
                },
            },
        },
    },
}
