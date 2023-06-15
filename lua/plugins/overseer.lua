local status_ok, overseer = pcall(require, "overseer")
if not status_ok then
        return
end

overseer.setup({
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
            ["f"] = "OpenFloat" -- open in floating window
        },
    },
})

local keymap = vim.keymap.set
local opts = {noremap = true, silent = true}

keymap("n", "<leader>or", "<cmd>OverseerRun<cr>", opts)
keymap("n", "<leader>on", "<cmd>OverSeerRunCmd<cr>", opts)
keymap("n", "<leader>oh", "<cmd>OverseerToggle left<cr>", opts)
keymap("n", "<leader>ol", "<cmd>OverseerToggle right<cr>", opts)

