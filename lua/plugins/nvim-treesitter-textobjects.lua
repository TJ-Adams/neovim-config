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
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["of"] = "@function.outer",
                ["if"] = "@function.inner",
                ["oc"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
        },
    },
})
