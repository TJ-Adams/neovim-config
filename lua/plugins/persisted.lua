return {
    "olimorris/persisted.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("persisted").setup()
        require("telescope").load_extension "persisted"
    end,
}
