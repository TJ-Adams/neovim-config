-- Make sure to have treesitter parsers installed for the
-- plugin to work.

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>dp", function()
    require("dropbar.api").pick()
end, opts)
