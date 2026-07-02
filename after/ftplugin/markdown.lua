vim.opt.conceallevel = 0

-- Format Markdown Files
vim.keymap.set("n", "<leader>bf", function()
    -- `--number` keeps consecutive 1. 2. 3. numbering; without it mdformat
    -- collapses every ordered-list item to `1.`.
    vim.cmd "%!mdformat --number --wrap 100 -"
end, { buffer = true, desc = "Format Buffer (mdformat)", silent = true })
