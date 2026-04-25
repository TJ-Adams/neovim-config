return {
    "alexghergh/nvim-tmux-navigation",
    keys = {
        {
            "<C-j>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateDown()
            end,
        },
        {
            "<C-k>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateUp()
            end,
        },
        {
            "<C-h>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
            end,
        },
        {
            "<C-l>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateRight()
            end,
        },

        -- Terminal Mode Mappings
        {
            "<C-j>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateDown()
            end,
            mode = "t",
        },
        {
            "<C-k>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateUp()
            end,
            mode = "t",
        },
        {
            "<C-h>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
            end,
            mode = "t",
        },
        {
            "<C-l>",
            function()
                require("nvim-tmux-navigation").NvimTmuxNavigateRight()
            end,
            mode = "t",
        },
    },
}
