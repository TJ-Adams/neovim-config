return {
    "folke/trouble.nvim",
    opts = {},
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>" },
        { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<cr>" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>" },
    },
}
