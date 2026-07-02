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

-- Smart terminal <Esc>: normally drop to Neovim's normal mode (so I can yank
-- program output), but pass <Esc> straight through to full-screen TUI programs
-- that need it themselves (lazygit, a nested nvim from `jj describe`, etc.).
--
-- We look at the foreground process group on the terminal's PTY. That group
-- includes descendants (e.g. an inner nvim plus its LSP servers), so the rule
-- is simply: if *any* foreground process is a known TUI, let it have the <Esc>.
local esc_passthrough = {
    nvim = true,
    vim = true,
    lazygit = true,
    htop = true,
    fzf = true,
    less = true,
    man = true,
}

local function terminal_has_foreground_tui()
    local pid = vim.b.terminal_job_pid
    if not pid then
        return false
    end

    -- TTY of the terminal's job (e.g. "ttys012").
    local tty = vim.fn.systemlist({ "ps", "-o", "tty=", "-p", tostring(pid) })[1]
    if not tty then
        return false
    end
    tty = vim.trim(tty)
    if tty == "" or tty == "??" then
        return false
    end

    -- Foreground processes carry '+' in their stat field.
    local procs = vim.fn.systemlist({ "ps", "-t", tty, "-o", "stat=,comm=" })
    for _, line in ipairs(procs) do
        local stat, comm = line:match("^(%S+)%s+(.*)$")
        if stat and comm and stat:find("+", 1, true) then
            local name = vim.fn.fnamemodify(comm, ":t")
            if esc_passthrough[name] then
                return true
            end
        end
    end

    return false
end

keymap("t", "<esc>", function()
    if terminal_has_foreground_tui() then
        return "<esc>" -- let the running program handle it
    end
    return [[<C-\><C-n>]] -- otherwise drop to Neovim's normal mode
end, { noremap = true, silent = true, expr = true })

-- Yank file paths
keymap("n", "<leader>ya", "<cmd>let @+ = expand('%:p')<cr>", opts) -- absolute file path
keymap("n", "<leader>yd", "<cmd>let @+ = expand('%:p:h')<cr>", opts) -- current directory
keymap("n", "<leader>yr", function() -- relative file path
    -- `expand('%')` / `%:.` return the full absolute path when the buffer was
    -- opened by absolute path, or when cwd and the buffer disagree on their
    -- symlink representation (e.g. cwd is a symlinked project dir but the file
    -- came in resolved via telescope oldfiles). Resolve both sides first so the
    -- relative path is computed against a common real path.
    local file = vim.fn.resolve(vim.fn.expand("%:p"))
    local cwd = vim.fn.resolve(vim.fn.getcwd())
    local rel
    if file:sub(1, #cwd + 1) == cwd .. "/" then
        rel = file:sub(#cwd + 2)
    else
        rel = vim.fn.fnamemodify(file, ":.") -- fall back to Vim's relativizer
    end
    vim.fn.setreg("+", rel)
end, opts)

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
keymap("n", "<leader>bf", vim.lsp.buf.format, { desc = "Format Buffer", silent = true })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", silent = true })

keymap("n", "<leader>h", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {desc = "Toggle Inlay Hints", silent = true })

-- Visual Mode Mappings
keymap("v", "<leader>bf", vim.lsp.buf.format, {desc = "Format Buffer", silent = true })

-- Add cursor position to quickfix list
keymap("n", "<leader>fa", function()
    local entry = {
        bufnr = vim.api.nvim_get_current_buf(),
        lnum = vim.api.nvim_win_get_cursor(0)[1],
        col = vim.api.nvim_win_get_cursor(0)[2],
        text = vim.api.nvim_get_current_line(),
    }
    vim.fn.setqflist({ entry }, 'a')
    if vim.fn.getqflist({ winid = 0 }).winid == 0 then
        vim.cmd('copen')
        vim.cmd('wincmd p')
    end
end, { desc = "Append position to quickfix list", silent = true })
