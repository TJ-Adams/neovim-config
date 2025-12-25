vim.keymap.set("n", "<leader>e", function()
    require("snacks").explorer.reveal()
end)

return {
    "folke/snacks.nvim",
    dependencies = {
        { "nvim-mini/mini.nvim", version = "*" },
        { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {
        input = {},
        styles = {
            input = {
                relative = "cursor",
            },
        },
        explorer = {
            -- don't use system trash when deleting files
            trash = false,
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
