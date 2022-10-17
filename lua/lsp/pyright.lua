local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

-- Setup lspconfig
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig["pyright"].setup(
    {
        capabilities = capabilities,
        on_attach = require("aerial").on_attach
    }
)
