local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<leader>do', vim.diagnostic.open_float, opts)
keymap('n', '[d', vim.diagnostic.goto_prev, opts)
keymap('n', ']d', vim.diagnostic.goto_next, opts)

-- Mappings.
local bufopts = { noremap=true, silent=true, buffer=bufnr }

vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)

vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', '<leader>bf', vim.lsp.buf.formatting, bufopts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)

