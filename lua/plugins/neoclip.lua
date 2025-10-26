require("neoclip").setup()

vim.keymap.set(
    "n",
    "yh",
    "<cmd>Telescope neoclip unnamed extra=plus<cr>",
    { desc = "Show yank history", silent = true }
)
