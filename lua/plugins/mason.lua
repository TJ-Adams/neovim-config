return {
    { "williamboman/mason.nvim", opts = {}, build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim", dependencies = {
        "williamboman/mason.nvim",
    } },
}
