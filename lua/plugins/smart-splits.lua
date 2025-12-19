local hydra = require "hydra"

local resize_hydra = hydra({
    name = "Resize Split",
    heads = {
        {
            "j",
            function()
                require("smart-splits").resize_down(1)
            end,
        },
        {
            "k",
            function()
                require("smart-splits").resize_up(1)
            end,
        },
        {
            "h",
            function()
                require("smart-splits").resize_left(1)
            end,
        },
        {
            "l",
            function()
                require("smart-splits").resize_right(1)
            end,
        },
        { "q", nil, { exit = true } },
    },
})

vim.keymap.set("n", "<leader>rs", function()
    resize_hydra:activate()
end)

return {
    "mrjones2014/smart-splits.nvim",
    dependencies = {
        "nvimtools/hydra.nvim",
    },
}
