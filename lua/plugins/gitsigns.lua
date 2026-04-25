return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    keys = {
        { "<leader>co", "<cmd>lua require('gitsigns').blame_line({full=true,})<cr>", desc = "Open Blame Info" },
        { "<leader>cp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
        { "<leader>cs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk Toggle" },
        { "<leader>cu", "<cmd>Gitsigns reset_hunk<cr>", desc = "Undo Hunk" },
        {
            "[c",
            function()
                require("gitsigns").nav_hunk("prev", { target = "all" })
            end,
            desc = "Go to Previous Hunk",
        },
        {
            "]c",
            function()
                require("gitsigns").nav_hunk("next", { target = "all" })
            end,
            desc = "Go to Next Hunk",
        },
    },
}
