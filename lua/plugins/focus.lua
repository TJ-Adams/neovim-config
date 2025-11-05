require("focus").setup({
    autoresize = {
        minwidth = 25, -- Force minimum width for the unfocused window
        minheight = 2, -- Force minimum height for the unfocused window
    },
    ui = {
        cursorline = false, -- Display a cursorline in the focussed window only
        signcolumn = false, -- Display signcolumn in the focussed window only
    },
})

vim.keymap.set("n", "<leader>foe", function()
    require("focus").focus_equalise()
end, { desc = "Equalize Splits", silent = true })

vim.keymap.set("n", "<leader>fom", function()
    require("focus").focus_maximise()
end, { desc = "Maximize Current Split", silent = true })

-- Start off with plugin disabled
require("focus").focus_equalise()
