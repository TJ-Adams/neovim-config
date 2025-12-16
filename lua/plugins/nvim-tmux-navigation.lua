vim.keymap.set("n", "<C-j>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateDown()
end)
vim.keymap.set("n", "<C-k>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateUp()
end)
vim.keymap.set("n", "<C-h>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
end)
vim.keymap.set("n", "<C-l>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateRight()
end)

vim.keymap.set("t", "<C-j>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateDown()
end)
vim.keymap.set("t", "<C-k>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateUp()
end)
vim.keymap.set("t", "<C-h>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
end)
vim.keymap.set("t", "<C-l>", function()
    require("nvim-tmux-navigation").NvimTmuxNavigateRight()
end)

return {
    "alexghergh/nvim-tmux-navigation",
}
