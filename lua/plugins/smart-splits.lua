local hydra_ok, hydra = pcall(require, "hydra")
if not hydra_ok then
    return
end

local resize_hydra = hydra({
    name = "Resize Split",
    config = {
        color = "pink",
    },
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
