local status_ok, goto_preview = pcall(require, "goto-preview")
if not status_ok then
    vim.notify("Couldn't find plugin: goto-preview", vim.log.levels.WARN, nil)
    return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function unset_keymaps()
    keymap("n", "q", "q", opts)
    keymap("n", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
    keymap("n", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
    keymap("n", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
    keymap("n", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)
end

local function move_right_and_unset()
    local key = vim.api.nvim_replace_termcodes("<C-w>L", true, false, true)
    local curr_win = vim.api.nvim_get_current_win()

    vim.api.nvim_feedkeys(key, "n", true)
    vim.api.nvim_win_set_var(curr_win, "is-goto-preview-window", false)
    unset_keymaps()
end

local function move_left_and_unset()
    local key = vim.api.nvim_replace_termcodes("<C-w>H", true, false, true)
    local curr_win = vim.api.nvim_get_current_win()

    vim.api.nvim_feedkeys(key, "n", true)
    vim.api.nvim_win_set_var(curr_win, "is-goto-preview-window", false)
    unset_keymaps()
end

local function move_down_and_unset()
    local key = vim.api.nvim_replace_termcodes("<C-w>J", true, false, true)
    local curr_win = vim.api.nvim_get_current_win()

    vim.api.nvim_feedkeys(key, "n", true)
    vim.api.nvim_win_set_var(curr_win, "is-goto-preview-window", false)
    unset_keymaps()
end

local function move_up_and_unset()
    local key = vim.api.nvim_replace_termcodes("<C-w>K", true, false, true)
    local curr_win = vim.api.nvim_get_current_win()

    vim.api.nvim_feedkeys(key, "n", true)
    vim.api.nvim_win_set_var(curr_win, "is-goto-preview-window", false)
    unset_keymaps()
end

goto_preview.setup({
    post_open_hook = function()
        keymap("n", "q", "<cmd>q<cr>", opts)
        keymap("n", "Q", "<cmd>lua require('goto-preview').close_all_win()<cr>", opts)
        keymap("n", "<C-l>", function()
            move_right_and_unset()
        end, opts)
        keymap("n", "<C-h>", function()
            move_left_and_unset()
        end, opts)
        keymap("n", "<C-j>", function()
            move_down_and_unset()
        end, opts)
        keymap("n", "<C-k>", function()
            move_up_and_unset()
        end, opts)
    end,
    post_close_hook = function()
        keymap("n", "q", "q", opts)
        keymap("n", "Q", "<cmd>Q<cr>", opts)
        keymap("n", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", opts)
        keymap("n", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", opts)
        keymap("n", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", opts)
        keymap("n", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", opts)
    end,
})

keymap("n", "<leader>gd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", opts)
keymap("n", "<leader>gt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", opts)
