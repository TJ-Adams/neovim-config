vim.keymap.set("n", "<leader>gd", function()
    require("goto-preview").goto_preview_definition()
end)
vim.keymap.set("n", "<leader>gt", function()
    require("goto-preview").goto_preview_type_definition()
end)

return {
    "rmagatti/goto-preview",
    opts = {
        post_open_hook = function()
            vim.keymap.set("n", "q", "<cmd>q<cr>", {})
            vim.keymap.set("n", "Q", "<cmd>lua require('goto-preview').close_all_win()<cr>", {})
        end,
        post_close_hook = function()
            vim.keymap.set("n", "q", "q", {})
            vim.keymap.set("n", "Q", "<cmd>Q<cr>", {})
        end,
    },
}
