vim.keymap.set("n", "<leader>gh", "<cmd>:DiffviewFileHistory % --no-merges<cr>", { desc = "Diffview File History" })

return {
    "sindrets/diffview.nvim",
}
