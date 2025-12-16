vim.keymap.set(
    "n",
    "<leader>co",
    "<cmd>lua require('gitsigns').blame_line({full=true,})<cr>",
    { desc = "Open Blame Info" }
)
vim.keymap.set("n", "<leader>cp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>cs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk Toggle" })
vim.keymap.set("n", "<leader>cu", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Undo Hunk" })
vim.keymap.set("n", "[c", function()
    require("gitsigns").nav_hunk("prev", { target = "all" })
end, { desc = "Go to Previous Hunk" })
vim.keymap.set("n", "]c", function()
    require("gitsigns").nav_hunk("next", { target = "all" })
end, { desc = "Go to Next Hunk" })

return {
    "lewis6991/gitsigns.nvim",
}
