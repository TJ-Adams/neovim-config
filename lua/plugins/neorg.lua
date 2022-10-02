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
            ["core.norg.dirman"] = {
                config = {
                    workspaces = {
                        work = "~/.local/notes/work",
                        personal = "~/.local/notes/personal",
                    }
                }
            }
        }
    }
)
