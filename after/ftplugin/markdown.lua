vim.opt.conceallevel = 0

-- Format Markdown Files
vim.keymap.set("n", "<leader>bf", function()
    vim.cmd "%!mdformat --wrap 100 -"
end, { buffer = true, desc = "Format Buffer (mdformat)", silent = true })
