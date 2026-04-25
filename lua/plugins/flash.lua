return {
    "folke/flash.nvim",
    lazy = false,
    ---@type Flash.Config
    opts = {
        label = {
            uppercase = false,
        },
        highlight = {
            backdrop = false,
        },
        modes = {
            search = {
                enabled = false,
            },
            char = {
                jump_labels = true,
                label = { exclude = "hjkliaydcrv" },
                highlight = {
                    backdrop = false,
                },
            },
        },
    },
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function() require("flash").jump() end,
            desc = "Flash Jump",
        },
        {
            "r",
            mode = "o",
            function() require("flash").remote() end,
            desc = "Flash Remote Yank",
        },
    },
}
