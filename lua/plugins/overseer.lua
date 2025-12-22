vim.keymap.set("n", "<leader>tr", "<cmd>OverseerRun<cr>")
vim.keymap.set("n", "<leader>th", "<cmd>OverseerToggle left<cr>")
vim.keymap.set("n", "<leader>tl", "<cmd>OverseerToggle right<cr>")

return {
    "stevearc/overseer.nvim",
    opts = {
        task_list = {
            keymaps = {
                ["r"] = { "keymap.run_action", opts = { action = "restart" } },
                ["v"] = { "keymap.run_action", opts = { action = "open vsplit" } },
                ["w"] = { "keymap.run_action", opts = { action = "watch" } },
                ["dd"] = false,
                ["d"] = { "keymap.run_action", opts = { action = "dispose" } },
                ["f"] = { "keymap.run_action", opts = { action = "open float" } },
                ["q"] = { "keymap.run_action", opts = { action = "open output in quickfix" } },
                ["<CR>"] = { "keymap.run_action" },
            },
        },
    },
}
