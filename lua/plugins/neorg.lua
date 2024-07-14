local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
    return
end

neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.keybinds"] = {},
        ["core.integrations.telescope"] = {},
        ["core.journal"] = {},
        -- ["core.ui.calendar"] = {}, // currently breaking neorg journal
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Global Neorg Journal Keymap
keymap("n", "<leader>njt", "<cmd>Neorg journal today<cr>", opts)

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.norg",
    callback = function()
        -- Keybinds for the journal module
        keymap("n", "<leader>njc", "<cmd>Neorg journal custom<cr>")
        keymap("n", "<leader>njf", "<cmd>Neorg journal tomorrow<cr>")
        keymap("n", "<leader>njy", "<cmd>Neorg journal yesterday<cr>")
        keymap("n", "<leader>njY", "<cmd>edit journal/2024/year.norg<cr>")
        keymap("n", "<leader>njL", "<cmd>edit journal/life.norg<cr>")
        keymap("n", "<leader>njw", "<cmd>edit journal/2024/week.norg<cr>")
        keymap("n", "<leader>njm", "<cmd>edit journal/2024/month.norg<cr>")
        keymap("n", "<leader>njq", "<cmd>edit journal/2024/quarter.norg<cr>")

        -- Keybinds for the calendar module
        keymap("n", "<leader>nc", '<cmd>:lua require"neorg".modules.get_module("core.ui.calendar").select_date({})<cr>')

        -- Misc
        keymap("n", "<leader>fni", "<cmd>Telescope neorg insert_link<cr>", opts)
        keymap("n", "<leader>fnh", "<cmd>Telescope neorg search_headings<cr>", opts)
    end,
})

-- Which Key Registration
local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

wk.add({
    { "<leader>t", group = "Tasks or Terminal" },
    { "<leader>ta", desc = "Tasks: Needs More Input" },
    { "<leader>tc", desc = "Tasks: Cancel" },
    { "<leader>td", desc = "Tasks: Done" },
    { "<leader>th", desc = "Tasks: Put on Hold" },
    { "<leader>ti", desc = "Tasks: High Priority" },
    { "<leader>tp", desc = "Tasks: In Progress" },
    { "<leader>tr", desc = "Tasks: Recurring" },
    { "<leader>tu", desc = "Tasks: Unfinished" },
})
