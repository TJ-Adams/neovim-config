-- Shorten functions
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Close Buffer
keymap("n", "<leader>bb", ":bp <BAR> bd #<CR>", opts)

-- Keymap for creating a terminal buffer and naming it
keymap("n", "<leader>tn", "<cmd>term<cr>:file ", opts)
keymap("t", "<esc>", [[<C-\><C-n>]], opts)

-- Yank file paths
keymap("n", "<leader>ya", "<cmd>let @+ = expand('%:p')<cr>", opts) -- absolute file path
keymap("n", "<leader>yr", "<cmd>let @+ = expand('%')<cr>", opts) -- relative file path

-- Switch Tabs
keymap("n", "[t", "<cmd>tabprevious<cr>", opts)
keymap("n", "]t", "<cmd>tabnext<cr>", opts)

-- Function to search for the visual selection without moving to the next match
local function search_vselection()
    -- Save the current visual selection into a variable
    local start_pos = vim.fn.getpos "."
    local end_pos = vim.fn.getpos "v"

    local search_pattern = vim.fn.getregion(start_pos, end_pos)

    search_pattern = table.concat(search_pattern, "\\n")

    -- Escape special characters. Might not work with '\'
    search_pattern = vim.fn.escape(search_pattern, "/.*$^~[]")

    print(search_pattern)

    -- Search for the pattern without jumping
    vim.fn.setreg("/", search_pattern)
    vim.opt.hls = true
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

keymap("v", "*", function()
    search_vselection()
end)

-- Keymap for searching for a pattern but not jumping anywhere
keymap("n", "<leader>/", function()
    vim.ui.input({ prompt = "Search: " }, function(input)
        vim.fn.setreg("/", input)
        vim.opt.hls = true
    end)
end)

-- This is so after a <COUNT>j/k, c-o will bring you back
vim.keymap.set('n', 'j', function()
  if vim.v.count > 0 then
    return "m'" .. vim.v.count .. 'j'
  end
  return 'j'
end, { expr = true })

vim.keymap.set('n', 'k', function()
  if vim.v.count > 0 then
    return "m'" .. vim.v.count .. 'k'
  end
  return 'k'
end, { expr = true })
