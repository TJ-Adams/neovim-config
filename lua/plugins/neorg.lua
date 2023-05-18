local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
    return
end

neorg.setup(
    {
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.integrations.telescope"] = {},
            ["core.manoeuvre"] = {},
            ["core.journal"] = {},
            ["core.ui.calendar"] = {},

            ["core.export"] = {
                config = {
                    export_dir = "/tmp/neorg_export/"
                }
            },
            ["core.completion"] = {
                config = {
                    engine = "nvim-cmp",
                }
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        work = "~/.local/notes/work",
                        personal = "~/.local/notes/personal",
                    }
                }
            },
            ["core.keybinds"] = {
                    config = {
                            hook = function(keybinds)
                                    -- Keybinds to make moving sections up and down easily
                                    keybinds.map("norg", "n", "gj", "<cmd>Neorg keybind norg core.manoeuvre.item_down<cr>")
                                    keybinds.map("norg", "n", "gk", "<cmd>Neorg keybind norg core.manoeuvre.item_up<cr>")
                                    keybinds.map("norg", "n", "]s", "<cmd>Neorg keybind norg core.integrations.treesitter.next.heading<cr>")
                                    keybinds.map("norg", "n", "[s", "<cmd>Neorg keybind norg core.integrations.treesitter.previous.heading<cr>")

                                    -- Keybinds for the journal module
                                    keybinds.map("norg", "n", "<leader>njc", '<cmd>Neorg journal custom<cr>')
                                    keybinds.map("norg", "n", "<leader>njt", '<cmd>Neorg journal today<cr>')
                                    keybinds.map("norg", "n", "<leader>njf", '<cmd>Neorg journal tomorrow<cr>')
                                    keybinds.map("norg", "n", "<leader>njy", '<cmd>Neorg journal yesterday<cr>')

                                    -- Keybinds for the calendar module
                                    keybinds.map("norg", "n", "<leader>nc", '<cmd>:lua neorg.modules.get_module("core.ui.calendar").select_date({})<cr>')
                            end,
                    }
            }
        }
    }
)

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>fnw", "<cmd>Telescope neorg switch_workspace<cr>", opts)
keymap("n", "<leader>fni", "<cmd>Telescope neorg insert_link<cr>", opts)
keymap("n", "<leader>fnh", "<cmd>Telescope neorg search_headings<cr>", opts)

-- Which Key Registration
local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

wk.register(
    {
        t = {
            name = "Tasks or Terminal",

            d = "Tasks: Done",
            c = "Tasks: Cancel",
            i = "Tasks: High Priority",
            h = "Tasks: Put on Hold",
            u = "Tasks: Unfinished",
            p = "Tasks: In Progress",
            r = "Tasks: Recurring",
        },
    },
    {prefix = "<leader>"}
)

