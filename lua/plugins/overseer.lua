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
    component_aliases = {
        -- Change defaults to keep tasks until I manually remove them
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
        }
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

keymap("n", "<leader>tr", "<cmd>OverseerRun<cr>", opts)
keymap("n", "<leader>tc", "<cmd>OverseerRunCmd<cr>", opts)
keymap("n", "<leader>th", "<cmd>OverseerToggle left<cr>", opts)
keymap("n", "<leader>tl", "<cmd>OverseerToggle right<cr>", opts)
keymap("n", "<leader>tp", "<cmd>OverseerRestartLast<cr>", opts)

-- Project specific tasks: Overseer supports vscode tasks. My recommendation is
-- to utilize that. At the root of your project you can put a .vscode/tasks.json
-- and overseer will see it and you can have tasks you only want to run for that
-- project and that project only.
