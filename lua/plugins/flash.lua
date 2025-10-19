local status_ok, flash = pcall(require, "flash")
if not status_ok then
    return
end

flash.setup({
    label = {
        -- Don't allow uppercase labels
        uppercase = false,
    },
    modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
            -- when `true`, flash will be activated during regular search by default.
            -- You can always toggle when searching with `require("flash").toggle()`
            enabled = true,
            search = {
                multi_window = false,
            },
        },
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap({ "n", "x", "o" }, "s", function()
    flash.jump()
end, opts)
keymap("o", "r", function()
    flash.remote()
end, opts)

keymap({ "n", "o", "x" }, "S", function()
    flash.treesitter()
end, opts)
