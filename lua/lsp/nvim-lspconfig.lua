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

wk.register({
    b = {
        f = "Format Buffer (LSP)",
    },
    d = {
        o = "Show Diagnostics on Line",
    },
    r = {
        n = "Rename Variable",
    },
    h = "Toggle Inlay Hints",
}, { prefix = "<leader>" })

local inlay_hints_enabled = false
local function toggle_inlay_hints()
    inlay_hints_enabled = not inlay_hints_enabled

    vim.lsp.inlay_hint(0, inlay_hints_enabled)
end

keymap("n", "<leader>h", function()
    toggle_inlay_hints()
end, opts)
