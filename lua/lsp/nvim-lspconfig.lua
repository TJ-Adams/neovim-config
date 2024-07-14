local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>do", vim.diagnostic.open_float, opts)

-- Mappings.
local bufopts = { noremap = true, silent = true, buffer = bufnr }

keymap("n", "gD", vim.lsp.buf.declaration, bufopts)

keymap("n", "K", vim.lsp.buf.hover, bufopts)

keymap("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
keymap("n", "<leader>bf", vim.lsp.buf.format, bufopts)
keymap("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

keymap("v", "<leader>bf", vim.lsp.buf.format, bufopts)

local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

wk.add({
    { "<leader>bf", desc = "Format Buffer (LSP)" },
    { "<leader>do", desc = "Show Diagnostics on Line" },
    { "<leader>h", desc = "Toggle Inlay Hints" },
    { "<leader>rn", desc = "Rename Variable" },
})

keymap("n", "<leader>h", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, opts)
