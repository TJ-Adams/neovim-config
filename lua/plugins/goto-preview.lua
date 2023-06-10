local status_ok, goto_preview = pcall(require, "goto-preview")
if not status_ok then
    return
end

goto_preview.setup()

local keymap = vim.keymap.set
local opts = {noremap = true, silent = true}

keymap("n", "<leader>df", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", opts)
keymap("n", "<leader>dc", "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
