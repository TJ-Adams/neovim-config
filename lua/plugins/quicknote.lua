local status_ok, quicknote = pcall(require, "quicknote")
if not status_ok then
    return
end

quicknote.setup({
    mode = "resident",
    sign = "N", -- This is used for the signs on the left side
    filetype = "norg",
    git_branch_recognizable = false, -- Don't separate notes by git branch
})

require("telescope").setup({
    extensions = {
        quicknote = {
            defaultScope = "CurrentBuffer",
        },
    },
})

require("telescope").load_extension "quicknote"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>na", "<cmd>:lua require('quicknote').NewNoteAtCurrentLine()<cr>", opts)
keymap("n", "<leader>no", "<cmd>:lua require('quicknote').OpenNoteAtCurrentLine()<cr>", opts)
keymap("n", "<leader>nd", "<cmd>:lua require('quicknote').DeleteNoteAtCurrentLine()<cr>", opts)

-- TODO: List doesn't seem to work. Maybe look into and make pull request
keymap("n", "<leader>npa", "<cmd>:lua require('quicknote').NewNoteAtCWD()<cr>", opts)
keymap("n", "<leader>npd", "<cmd>:lua require('quicknote').DeleteNoteAtCWD()<cr>", opts)
keymap("n", "<leader>npo", "<cmd>Telescope quicknote scope=CWD<cr>", opts)

keymap("n", "<leader>nb", "<cmd>:lua require('quicknote').ListNotesForCurrentBuffer()<cr>", opts)
