-- Render markdown in place (headings, lists, checkboxes, code blocks, tables).
-- Off by default; <leader>md toggles it for the current buffer only.
return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    keys = {
        {
            "<leader>md",
            function()
                require("render-markdown").buf_toggle()
            end,
            ft = "markdown",
            desc = "Toggle Markdown Render",
        },
    },
    opts = {
        -- Every buffer starts unrendered; buf_toggle flips just the current one.
        enabled = false,
    },
}
