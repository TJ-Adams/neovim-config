vim.keymap.set("n", "<leader>mm", function()
    codewindow.toggle_minimap()
end, { desc = "Toggle MiniMap" })

return {
    "gorbit99/codewindow.nvim",
}
