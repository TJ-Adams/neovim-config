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

local hydra_ok, hydra = pcall(require, "hydra")
if not hydra_ok then
    return
end

local movement_hydra_hydra = hydra({
    name = "Function Movement Hydra",
    config = {
        -- TODO: Convert to a red Hydra. Because Hydra occupies the event loop
        --       you have to do extra work to release it and still be in a hydra
        --       state
        color = "pink",
    },
    heads = {
        {
            "j",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_next_start('@function.outer', 'textobjects')<cr>",
        },
        {
            "k",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_previous_start('@function.outer', 'textobjects')<cr>",
        },
        { "q", nil, { exit = true } },
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>mf", function()
    movement_hydra_hydra:activate()
end, opts)
