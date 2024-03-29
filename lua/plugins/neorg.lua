local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
    return
end

neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.integrations.telescope"] = {},
        ["core.journal"] = {},
        ["core.ui.calendar"] = {},

        ["core.export"] = {
            config = {
                export_dir = "/tmp/neorg_export/",
            },
        },
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.dirman"] = {
            config = {
                workspaces = {
                    work = "~/.local/notes/work",
                    personal = "~/.local/notes/personal",
                },
            },
        },
        ["core.keybinds"] = {
            config = {
                hook = function(keybinds)
                    -- Keybinds to make moving sections up and down easily
                    keybinds.map(
                        "norg",
                        "n",
                        "]s",
                        "<cmd>Neorg keybind norg core.integrations.treesitter.next.heading<cr>"
                    )
                    keybinds.map(
                        "norg",
                        "n",
                        "[s",
                        "<cmd>Neorg keybind norg core.integrations.treesitter.previous.heading<cr>"
                    )

                    -- Keybinds for the journal module
                    keybinds.map("norg", "n", "<leader>njc", "<cmd>Neorg journal custom<cr>")
                    keybinds.map("norg", "n", "<leader>njf", "<cmd>Neorg journal tomorrow<cr>")
                    keybinds.map("norg", "n", "<leader>njy", "<cmd>Neorg journal yesterday<cr>")
                    keybinds.map("norg", "n", "<leader>njY", "<cmd>edit journal/2023/year.norg<cr>")
                    keybinds.map("norg", "n", "<leader>njL", "<cmd>edit journal/life.norg<cr>")
                    keybinds.map("norg", "n", "<leader>njw", "<cmd>edit journal/2023/week.norg<cr>")
                    keybinds.map("norg", "n", "<leader>njm", "<cmd>edit journal/2023/month.norg<cr>")
                    keybinds.map("norg", "n", "<leader>njq", "<cmd>edit journal/2023/quarter.norg<cr>")

                    -- Keybinds for the calendar module
                    keybinds.map(
                        "norg",
                        "n",
                        "<leader>nc",
                        '<cmd>:lua require"neorg".modules.get_module("core.ui.calendar").select_date({})<cr>'
                    )
                end,
            },
        },
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>fnw", "<cmd>Telescope neorg switch_workspace<cr>", opts)
keymap("n", "<leader>fni", "<cmd>Telescope neorg insert_link<cr>", opts)
keymap("n", "<leader>fnh", "<cmd>Telescope neorg search_headings<cr>", opts)

-- Global Neorg Journal Keymap
keymap("n", "<leader>njt", "<cmd>Neorg journal today<cr>", opts)

-- Which Key Registration
local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

wk.register({
    t = {
        name = "Tasks or Terminal",

        a = "Tasks: Needs More Input",
        d = "Tasks: Done",
        c = "Tasks: Cancel",
        i = "Tasks: High Priority",
        h = "Tasks: Put on Hold",
        u = "Tasks: Unfinished",
        p = "Tasks: In Progress",
        r = "Tasks: Recurring",
    },
}, { prefix = "<leader>" })
