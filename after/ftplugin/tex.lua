vim.opt.scrollbind = false -- Don't bind scrolls for splits
vim.opt.expandtab = true -- Don't use tabs in latex files
vim.opt.conceallevel = 0

-- Format LaTeX Files
vim.keymap.set("n", "<leader>bf", function()
    -- latexindent needs `-m` (modifyLineBreaks) for `textWrapOptions` to take
    -- effect, which wraps long lines (e.g. \item text) at `columns`. Without it
    -- latexindent only re-indents and never wraps.
    -- `-g /dev/null` and `-c /tmp/` keep its log/temp files out of the cwd.
    local columns = 80
    local yaml = string.format("defaultIndent: '    ', modifyLineBreaks:textWrapOptions:columns:%d", columns)
    vim.cmd(string.format("%%!latexindent -m -g /dev/null -c /tmp/ -y %s -", vim.fn.shellescape(yaml)))
end, { buffer = true, desc = "Format Buffer (latexindent)", silent = true })
