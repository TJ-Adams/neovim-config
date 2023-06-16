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

vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
                vim.notify("No tasks found", vim.log.levels.WARN)
        else
                overseer.run_action(tasks[1], "restart")
        end
end, {})

local keymap = vim.keymap.set
local opts = {noremap = true, silent = true}

keymap("n", "<leader>or", "<cmd>OverseerRun<cr>", opts)
keymap("n", "<leader>on", "<cmd>OverseerRunCmd<cr>", opts)
keymap("n", "<leader>oh", "<cmd>OverseerToggle left<cr>", opts)
keymap("n", "<leader>ol", "<cmd>OverseerToggle right<cr>", opts)
keymap("n", "<leader>op", "<cmd>OverseerRestartLast<cr>", opts)

