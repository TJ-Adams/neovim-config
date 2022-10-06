local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
    return
end

neorg.setup(
    {
        load = {
            ["core.defaults"] = {},
            ["core.norg.concealer"] = {},
            ["core.integrations.telescope"] = {},
            ["core.norg.manoeuvre"] = {},

            ["core.norg.completion"] = {
                config = {
                    engine = "nvim-cmp",
                }
            },
            ["core.norg.dirman"] = {
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
                                    keybinds.map("norg", "n", "gj", "<cmd>Neorg keybind norg core.norg.manoeuvre.item_down<cr>")
                                    keybinds.map("norg", "n", "gk", "<cmd>Neorg keybind norg core.norg.manoeuvre.item_up<cr>")
                            end,
                    }
            }
        }
    }
)
