-- In diff windows (diffview, :diffthis) fall back to the built-in [c/]c, which
-- walk the diff itself; gitsigns has nothing attached to those buffers.
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
                if vim.wo.diff then
                    vim.cmd.normal({ vim.v.count1 .. "[c", bang = true })
                else
                    require("gitsigns").nav_hunk("prev", { target = "all" })
                end
            end,
            desc = "Go to Previous Hunk",
        },
        {
            "]c",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ vim.v.count1 .. "]c", bang = true })
                else
                    require("gitsigns").nav_hunk("next", { target = "all" })
                end
            end,
            desc = "Go to Next Hunk",
        },
    },
}
