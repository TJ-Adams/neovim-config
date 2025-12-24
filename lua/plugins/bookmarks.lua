vim.keymap.set("n", "mg", "<cmd>Telescope bookmarks<cr>", { desc = "Go to Bookmark", silent = true })

vim.keymap.set("n", "ma", function()
    require("bookmarks").add_bookmarks(false)
end)
vim.keymap.set("n", "md", function()
    require("bookmarks.list").delete_on_virt()
end)
vim.keymap.set("n", "ms", function()
    require("bookmarks.list").show_desc()
end)

return {
    "crusj/bookmarks.nvim",
    opts = {
        mappings_enabled = false,
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
