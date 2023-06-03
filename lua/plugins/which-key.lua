local status_ok, wk = pcall(require, "which-key")
if not status_ok then
    return
end

wk.register(
    {
        a = {
            name = "Aerial Commands"
        },
        b = {
            name = "Buffer Specific Actions"
        },
        c = {
            name = "Git Hunks | ChatGPT | Code Actions"
        },
        d = {
            name = "Preview in Floating Window"
        },
        f = {
            name = "Find with Telescope"
        },
        i = {
            name = "Incoming Calls"
        },
        l = {
            name = "Lazy Git | Lazy Packer"
        },
        n = {
            name = "Neorg",
            j = {
                name = "Journal"
            }
        },
        o = {
            name = "Outgoing Calls"
        },
        r = {
            name = "Rename"
        },
        s = {
            name = "Source $MYVIMRC"
        },
        t = {
            name = "ToggleTerm | Treesitter"
        },
        x = {
            name = "Trouble"
        },
    },
    {prefix = "<leader>"}
)
