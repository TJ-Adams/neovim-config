vim.keymap.set("n", "<leader>dp", function()
    require("dropbar.api").pick()
end, { desc = "Dropbar Pick" })

return {
    "Bekaboo/dropbar.nvim",
    opts = {
        bar = {
            truncate = false,
        },
    },
}
