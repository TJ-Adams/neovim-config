vim.keymap.set({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "Flash Jump" })
vim.keymap.set("o", "r", function()
    require("flash").remote()
end, { desc = "Flash Remote Yank" })

return {
    "folke/flash.nvim",
    opts = {

        label = {
            -- Don't allow uppercase labels
            uppercase = false,
        },
        highlight = {
            backdrop = false,
        },
        modes = {
            -- options used when flash is activated through
            -- a regular search with `/` or `?`
            search = {
                -- when `true`, flash will be activated during regular search by default.
                -- You can always toggle when searching with `require("flash").toggle()`
                enabled = true,
                search = {
                    multi_window = false,
                },
            },
            char = {
                jump_labels = true,
                label = { exclude = "hjkliaydc" },
                highlight = {
                    backdrop = false,
                },
            },
        },
    },
}
