vim.keymap.set("n", "<leader>tr", "<cmd>OverseerRun<cr>")
vim.keymap.set("n", "<leader>tc", "<cmd>OverseerRunCmd<cr>")
vim.keymap.set("n", "<leader>th", "<cmd>OverseerToggle left<cr>")
vim.keymap.set("n", "<leader>tl", "<cmd>OverseerToggle right<cr>")

return {
    "stevearc/overseer.nvim",
    opts = {
        task_list = {
            bindings = {
                ["<C-u>"] = "ScrollOutputUp",
                ["<C-d>"] = "ScrollOutputDown",

                -- Don't map these keybinds
                ["<C-l>"] = false,
                ["<C-h>"] = false,
                ["<C-k>"] = false,
                ["<C-j>"] = false,

                ["q"] = "OpenQuickFix", -- open in quickfix
                ["f"] = "OpenFloat", -- open in floating window
            },
        },
        component_aliases = {
            -- Change defaults to keep tasks until I manually remove them
            default = {
                { "display_duration", detail_level = 2 },
                "on_output_summarize",
                "on_exit_set_status",
                "on_complete_notify",
            },
        },
    },
}
