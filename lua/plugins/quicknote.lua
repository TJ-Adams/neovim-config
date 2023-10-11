local status_ok, quicknote = pcall(require, "quicknote")
if not status_ok then
    return
end

quicknote.setup({
    mode = "resident",
    sign = "N", -- This is used for the signs on the left side
    filetype = "norg",
    git_branch_recognizable = true, -- Separate notes by git branch
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

keymap("n", "mna", "<cmd>:lua require('quicknote').NewNoteAtCurrentLine()<cr>", opts)
keymap("n", "mno", "<cmd>:lua require('quicknote').OpenNoteAtCurrentLine()<cr>", opts)
keymap("n", "mnd", "<cmd>:lua require('quicknote').DeleteNoteAtCurrentLine()<cr>", opts)

-- TODO: List doesn't seem to work. Maybe look into and make pull request
keymap("n", "mnpa", "<cmd>:lua require('quicknote').NewNoteAtCWD()<cr>", opts)
keymap("n", "mnpd", "<cmd>:lua require('quicknote').DeleteNoteAtCWD()<cr>", opts)
keymap("n", "mnpl", "<cmd>:lua require('quicknote').ListNotesForCWD()<cr>", opts)
keymap("n", "mnpo", "<cmd>:lua require('quicknote').OpenNoteAtCWD()<cr>", opts)

keymap("n", "mnb", "<cmd>:lua require('quicknote').ListNotesForCurrentBuffer()<cr>", opts)
