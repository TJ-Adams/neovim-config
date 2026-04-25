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
                    win = {
                        list = {
                            keys = {
                                ["f"] = "focus_input", -- Map 'f' to start filtering
                                -- Disable keymaps in favor or default behavior
                                ["/"] = false,
                                ["?"] = false,
                            },
                        },
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader>e",
            function()
                require("snacks").explorer.reveal()
            end,
        },
    },
}
