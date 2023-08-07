local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>do", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)

-- Mappings.
local bufopts = { noremap = true, silent = true, buffer = bufnr }

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)

vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, bufopts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

vim.keymap.set("v", "<leader>bf", vim.lsp.buf.format, bufopts)

local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

wk.register({
    d = {
        o = "Show Diagnostics on Line",
    },
}, { prefix = "<leader>" })
