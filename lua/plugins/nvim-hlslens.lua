local status_ok, hlslens = pcall(require, "hlslens")
if not status_ok then
    return
end

hlslens.setup({
    calm_down = {
        -- Disable highlighting when I move the cursor out of match range
        default = true,
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
keymap("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)

keymap("n", "*", function()
    vim.fn.setreg("/", "\\<" .. vim.fn.expand "<cword>" .. "\\>")
    vim.opt.hls = true
    require("hlslens").start()
end, opts)
