local status_ok, bookmarks = pcall(require, "bookmarks")
if not status_ok then
    return
end

bookmarks.setup({
    mappings_enabled = true,
    keymap = {
        -- Global Mappings
        toggle = "mt", -- Toggle Marks Window
        add = "ma",
        delete_on_virt = "md", -- Delete Mark
        show_desc = "ms", -- Show mark desc

        -- Mappings For Bookmarks Window
        jump = "<CR>",
        delete = "dd",
        order = "ro", -- Order bookmarks by frequency or updated_time
    },

    fix_enable = true, -- Try following line number as file changes

    virt_text = "🔖", -- Show virt text at the end of bookmarked lines
    virt_pattern = { "*.go", "*.lua", "*.sh", "*.php", "*.rs", "*.c", "*.cpp", "*.norg", "*.h", "*.hpp" }, -- Show virt text only on matched pattern
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "mg", "<cmd>Telescope bookmarks<cr>", opts) -- mark go to
