local status_ok, flash = pcall(require, "flash")
if not status_ok then
    return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap({ "n", "x", "o" }, "s", function()
    flash.jump()
end, opts)
keymap("o", "r", function()
    flash.remote()
end, opts)
