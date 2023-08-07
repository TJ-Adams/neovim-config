local status_ok, tldr = pcall(require, "tldr")
if not status_ok then
    return
end

tldr.setup({})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>fd", "<cmd>Telescope tldr<cr>", opts)
