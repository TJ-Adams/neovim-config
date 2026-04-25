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
keymap("n", "<leader>yd", "<cmd>let @+ = expand('%:p:h')<cr>", opts) -- current directory
keymap("n", "<leader>yr", "<cmd>let @+ = expand('%')<cr>", opts) -- relative file path

-- Switch Tabs
keymap("n", "[t", "<cmd>tabprevious<cr>", opts)
keymap("n", "]t", "<cmd>tabnext<cr>", opts)

-- Function to search for the visual selection without moving to the next match
local function search_vselection()
    local start_pos = vim.fn.getpos(".")
    local end_pos = vim.fn.getpos("v")

    local lines = vim.fn.getregion(start_pos, end_pos)

    -- Escape backslashes FIRST, before we add any of our own
    for i, line in ipairs(lines) do
        lines[i] = vim.fn.escape(line, "\\/.*$^~[]")
    end

    -- Now join with \n (which matches newline in Vim search)
    local search_pattern = table.concat(lines, "\\n")

    vim.fn.setreg("/", search_pattern)
    vim.opt.hls = true
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
        "n",
        true
    )
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

-- Clear Highlights ("Dismiss Highlights" mnemonic)
vim.keymap.set("n", "<leader>dh", function()
    vim.cmd "noh"
end, { desc = "Clear Highlights", silent = true })


-- LSP Specific Keymaps
keymap("n", "gD", vim.lsp.buf.declaration, {desc = "Go To Declarations", silent = true })
keymap("n", "K", vim.lsp.buf.hover, {desc = "Info Under Cursor", silent = true })

keymap("n", "<leader>do", function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", silent = true })
keymap("n", "<leader>bf", vim.lsp.buf.format, { desc = "Format Buffer", silent = true })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", silent = true })

keymap("n", "<leader>h", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {desc = "Toggle Inlay Hints", silent = true })

-- Visual Mode Mappings
keymap("v", "<leader>bf", vim.lsp.buf.format, {desc = "Format Buffer", silent = true })
