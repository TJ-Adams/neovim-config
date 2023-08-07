local hydra = require "hydra"

hydra({
    name = "Screen Scroll",
    mode = "n",
    body = "<leader>",
    heads = {
        { "j", "<C-e>" },
        { "k", "<C-y>" },
        { "h", "2zh" },
        { "l", "2zl", { desc = "Scroll Screen" } },

        { "J", "<C-w>j" },
        { "K", "<C-w>k" },
        { "H", "<C-w>h" },
        { "L", "<C-w>l", { desc = "Change Split" } },

        { "q", nil, { exit = true } },
    },
})
