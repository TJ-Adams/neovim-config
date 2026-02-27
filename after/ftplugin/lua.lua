local function format_current_file()
    vim.cmd("silent !stylua " .. vim.fn.shellescape(vim.fn.expand "%"))

    -- Reload buffer to see changes immediately
    vim.cmd "e!"
end

vim.keymap.set("n", "<leader>bf", function()
    format_current_file()
end, { desc = "Format current file with stylua", silent = true })
