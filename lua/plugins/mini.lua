local status_ok
local pairs
local cursorword
local minimap

status_ok, pairs = pcall(require, "mini.pairs")
if not status_ok then
    return
end

status_ok, cursorword = pcall(require, "mini.cursorword")
if not status_ok then
        return
end

status_ok, minimap = pcall(require, "mini.map")

pairs.setup()
cursorword.setup()
minimap.setup (
    {
        integrations = {
            minimap.gen_integration.builtin_search(),
            minimap.gen_integration.gitsigns(),
        },
        symbols = {
            encode = minimap.gen_encode_symbols.dot("4x2"),

            scroll_line = '█',
            scroll_view = '▒',
        },
    }
)

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>mt", "<cmd>lua MiniMap.toggle()<cr>", opts)
keymap("n", "<leader>ms", "<cmd>lua MiniMap.toggle_side()<cr>", opts)
keymap("n", "<leader>mf", "<cmd>lua MiniMap.toggle_focus()<cr>", opts)

-- Add so highlights will show up in minimap
-- TODO: This conflicts with the mappings in nvim-hlslens.lua. Fix.
--keymap("n", "n", "n .. <cmd>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<cr>", opts)
--keymap("n", "N", "N .. <cmd>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<cr>", opts)
--keymap("n", "*", "* .. <cmd>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<cr>", opts)
--keymap("n", "#", "# .. <cmd>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<cr>", opts)
