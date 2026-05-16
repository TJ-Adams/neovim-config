return {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
        { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    opts = {
        backend = "delta",
    },
    keys = {
        {
            "<leader>ca",
            function()
                require("tiny-code-action").code_action()
            end,
        },
    },
}
