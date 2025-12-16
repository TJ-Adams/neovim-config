return {
    "nvimtools/hydra.nvim",
    config = function()
        local hydra = require "hydra"

        local scroll_hydra = hydra({
            name = "Screen Scroll",
            heads = {
                { "j", "2<C-e>" },
                { "k", "2<C-y>" },
                { "h", "2zh" },
                { "l", "2zl", { desc = "Scroll Screen" } },
                { "q", nil, { exit = true } },
            },
        })

        vim.keymap.set("n", "<leader>j", function()
            local key = vim.api.nvim_replace_termcodes("<C-e>", true, false, true)
            vim.api.nvim_feedkeys(key, "n", true)
            scroll_hydra:activate()
        end, { desc = "Scroll Hydra" })
        vim.keymap.set("n", "<leader>k", function()
            local key = vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
            vim.api.nvim_feedkeys(key, "n", true)
            scroll_hydra:activate()
        end, { desc = "Scroll Hydra" })
    end,
}
