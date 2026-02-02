vim.keymap.set("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], {})
vim.keymap.set("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], {})
vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], {})
vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], {})
vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], {})

vim.keymap.set("n", "*", function()
    vim.fn.setreg("/", "\\<" .. vim.fn.expand "<cword>" .. "\\>")
    vim.opt.hls = true
    require("hlslens").start()
end)

-- Clear Highlights ("Dismiss Highlights" mnemonic)
vim.keymap.set("n", "<leader>dh", function()
    vim.cmd "noh"
end, { desc = "Clear Highlights", silent = true })

return {
    "kevinhwang91/nvim-hlslens",
    opts = {
        calm_down = false,
    },
}
