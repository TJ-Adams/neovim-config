return {
    "AckslD/nvim-neoclip.lua",
    lazy = false,
    dependencies = {
        { "kkharji/sqlite.lua", module = "sqlite" },
    },
    opts = {},
    keys = {
        { "yh", "<cmd>Telescope neoclip unnamed extra=plus<cr>", desc = "Show yank history" },
    },
}
