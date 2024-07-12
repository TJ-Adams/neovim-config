local status_ok, codewindow = pcall(require, "codewindow")
if not status_ok then
    return
end

codewindow.setup()

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>mm", function()
    codewindow.toggle_minimap()
end, opts)
