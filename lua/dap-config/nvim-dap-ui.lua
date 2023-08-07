local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
    return
end

dapui.setup()

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", opts)
