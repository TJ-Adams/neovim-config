return {
    "nvim.undotree",
    virtual = true,
    config = function()
        -- This replaces vim.cmd("packadd nvim.undotree")
        vim.cmd "packadd nvim.undotree"
        vim.keymap.set("n", "<leader>u", require("undotree").open, { desc = "Toggle Undotree" })
    end,
}
