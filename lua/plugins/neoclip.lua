vim.keymap.set(
    "n",
    "yh",
    "<cmd>Telescope neoclip unnamed extra=plus<cr>",
    { desc = "Show yank history", silent = true }
)

return {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
        { "kkharji/sqlite.lua", module = "sqlite" },
    },
    opts = {},
}
