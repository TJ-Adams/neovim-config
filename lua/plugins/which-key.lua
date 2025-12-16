return {
    "folke/which-key.nvim",
    config = function()
        require("which-key").add({
            { "<leader>a", group = "Aerial Commands" },
            { "<leader>b", group = "Buffer Specific Actions" },
            { "<leader>c", group = "Git Hunks | Code Actions" },
            { "<leader>d", group = "DAP | Diagnostics | Diff" },
            { "<leader>f", group = "Find with Telescope" },
            { "<leader>g", group = "Preview Symbols" },
            { "<leader>i", group = "Incoming Calls" },
            { "<leader>l", group = "Lazy Git | Lazy Package Manager" },
            { "<leader>m", group = "Movement Mode | Minimap" },
            { "<leader>n", group = "Neorg" },
            { "<leader>nj", group = "Journal" },
            { "<leader>o", group = "Outgoing Calls" },
            { "<leader>r", group = "Rename | Resize" },
            { "<leader>t", group = "Terminal | Overseer" },
            { "<leader>x", group = "Trouble" },
            { "<leader>y", group = "Yank Current File" },
        })
    end,
}
