vim.keymap.set("n", "<leader>dn", "<cmd>Noice dismiss<cr>", { desc = "Dismiss Noice" })

return {
    "folke/noice.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
        presets = {
            bottom_search = true,
            command_palette = true,
        },

        messages = {
            enabled = false,
        },

        popupmenu = {
            enabled = false,
        },

        lsp = {
            signature = {
                -- I already have a signature provider. In the
                -- future I may consolidate though
                enabled = false,
            },
        },
    },
}
