return {
    "Bekaboo/dropbar.nvim",
    lazy = false,
    keys = {
        {
            "<leader>dp",
            function()
                require("dropbar.api").pick()
            end,
            desc = "Dropbar Pick",
        },
    },
    opts = {
        bar = {
            truncate = false,
        },
    },
}
