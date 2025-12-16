return {
    "nvim-lualine/lualine.nvim",
    opts = {
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
    },
}
