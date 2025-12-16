local function unset_keymaps()
    vim.keymap.set("n", "q", "q", {})
    vim.keymap.set("n", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", {})
    vim.keymap.set("n", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", {})
    vim.keymap.set("n", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", {})
    vim.keymap.set("n", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", {})
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

vim.keymap.set("n", "<leader>gd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", {})
vim.keymap.set("n", "<leader>gt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", {})

return {
    "rmagatti/goto-preview",
    opts = {
        post_open_hook = function()
            vim.keymap.set("n", "q", "<cmd>q<cr>", {})
            vim.keymap.set("n", "Q", "<cmd>lua require('goto-preview').close_all_win()<cr>", {})
            vim.keymap.set("n", "<C-l>", function()
                move_right_and_unset()
            end, {})
            vim.keymap.set("n", "<C-h>", function()
                move_left_and_unset()
            end, {})
            vim.keymap.set("n", "<C-j>", function()
                move_down_and_unset()
            end, {})
            vim.keymap.set("n", "<C-k>", function()
                move_up_and_unset()
            end, {})
        end,
        post_close_hook = function()
            vim.keymap.set("n", "q", "q", {})
            vim.keymap.set("n", "Q", "<cmd>Q<cr>", {})
            vim.keymap.set("n", "<C-j>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>", {})
            vim.keymap.set("n", "<C-k>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>", {})
            vim.keymap.set("n", "<C-h>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>", {})
            vim.keymap.set("n", "<C-l>", ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>", {})
        end,
    },
}
