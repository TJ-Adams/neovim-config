local status_ok, hlslens = pcall(require, "hlslens")
if not status_ok then
    return
end

hlslens.setup()

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "n",
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    opts)
keymap("n", "N",
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    opts)
keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>N]], opts)
keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)
