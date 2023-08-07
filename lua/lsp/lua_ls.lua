local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

lspconfig["lua_ls"].setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                },
            },
        },
    },
})
