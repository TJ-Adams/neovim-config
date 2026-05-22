return {
    "Hajime-Suzuki/vuffers.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        exclude = {
            filenames = {},
        },
        keymaps = {
            view = {
                move_up = "<leader>bk",
                move_down = "<leader>bj",
            },
        },
        view = {
            show_file_extension = true,
        },
    },
    keys = {
        {
            "<leader>bl",
            function()
                require("vuffers").toggle()
            end,
        },
        {
            "<S-h>",
            function()
                require("vuffers").go_to_buffer_by_count({ direction = "prev", count = 1 })
            end,
        },
        {
            "<S-l>",
            function()
                require("vuffers").go_to_buffer_by_count({ direction = "next", count = 1 })
            end,
        },
    },
}


