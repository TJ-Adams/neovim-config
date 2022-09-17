require "lspconfig".clangd.setup(
    {
        on_attach = require("aerial").on_attach
    }
)
