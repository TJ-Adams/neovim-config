vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>")
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>")

return {
    "folke/trouble.nvim",
    opts = {},
}
