vim.keymap.set("n", "mg", "<cmd>Telescope bookmarks<cr>", { desc = "Go to Bookmark", silent = true })

return {
    "crusj/bookmarks.nvim",
    opts = {
        mappings_enabled = true,
        keymap = {
            add = "ma",
            delete_on_virt = "md", -- Delete Mark
            show_desc = "ms", -- Show mark desc
        },

        fix_enable = true, -- Try following line number as file changes

        virt_text = "🔖", -- Show virt text at the end of bookmarked lines
        virt_pattern = { "*.go", "*.lua", "*.sh", "*.php", "*.rs", "*.c", "*.cpp", "*.norg", "*.h", "*.hpp" }, -- Show virt text only on matched pattern
    },
}
