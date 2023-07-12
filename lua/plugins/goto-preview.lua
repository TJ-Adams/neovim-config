local status_ok, goto_preview = pcall(require, "goto-preview")
if not status_ok then
    vim.notify("Couldn't find plugin: goto-preview", vim.log.levels.WARN, nil)
    return
end

goto_preview.setup()

local keymap = vim.keymap.set
local opts = {noremap = true, silent = true}

keymap("n", "<leader>gd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", opts)
keymap("n", "<leader>gt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", opts)
