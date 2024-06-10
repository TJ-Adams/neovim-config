local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

lualine.setup({
    options = {
        theme = "gruvbox",
    },
    sections = {
        lualine_c = {
            {
                "filename",
                path = 1,
            },
        },
    },
    inactive_sections = {
        lualine_c = {
            {
                "filename",
                path = 1,
            },
        },
    },
})
