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
        { "q", nil, { exit = true } },
    },
})
