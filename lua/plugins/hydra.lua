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
    local key = vim.api.nvim_replace_termcodes("<C-e>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", true)
    scroll_hydra:activate()
end, opts)
keymap("n", "<leader>k", function()
    local key = vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", true)
    scroll_hydra:activate()
end, opts)
