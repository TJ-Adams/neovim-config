local status_ok, hydra = pcall(require, "hydra")
if not status_ok then
    return
end

local scroll_hydra = hydra({
    name = "Screen Scroll",
    heads = {
        { "j", "<C-e>" },
        { "k", "<C-y>" },
        { "h", "2zh" },
        { "l", "2zl", { desc = "Scroll Screen" } },
        { "q", nil, { exit = true } },
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>j", function()
    scroll_hydra:activate()
end, opts)
keymap("n", "<leader>k", function()
    scroll_hydra:activate()
end, opts)
