local status_ok, textobjects = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

textobjects.setup({
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["<leader>J"] = "@function.outer",
                ["<leader>L"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>K"] = "@function.outer",
                ["<leader>H"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
            },
        },
    },
})

-- TODO: Add hydra support. The below keymap is an example of how to
--       call some of the swap capabilities because the plugin doesn't
--       normally expose it
--keymap("n", "<leader>X", "<cmd>lua require 'nvim-treesitter.textobjects.swap'.swap_next('@function.outer', 'textobjects')<cr>", opts)
