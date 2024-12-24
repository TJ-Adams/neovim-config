local keymap = vim.keymap.set

-- Normal Mode Mappings
keymap("n", "gD", vim.lsp.buf.declaration, {desc = "Go To Declarations", silent = true })
keymap("n", "K", vim.lsp.buf.hover, {desc = "Info Under Cursor", silent = true })

keymap("n", "<leader>do", vim.diagnostic.open_float, {desc = "Show Diagnostics", silent = true })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, {desc = "Code Action", silent = true })
keymap("n", "<leader>bf", vim.lsp.buf.format, {desc = "Format Buffer", silent = true })
keymap("n", "<leader>rn", vim.lsp.buf.rename, {desc = "Rename", silent = true })

keymap("n", "<leader>h", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {desc = "Toggle Inlay Hints", silent = true })

-- Visual Mode Mappings
keymap("v", "<leader>bf", vim.lsp.buf.format, {desc = "Format Buffer", silent = true })
