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
    name = "Function Movement Hydra\n",
    config = {
        -- TODO: Convert to a red Hydra. Because Hydra occupies the event loop
        --       you have to do extra work to release it and still be in a hydra
        --       state
        color = "pink",
    },
    heads = {
        -- Functions
        {
            "f",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_next_start('@function.outer', 'textobjects')<cr>",
        },
        {
            "F",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_previous_start('@function.outer', 'textobjects')<cr>",
        },

        -- Objects / Classes
        {
            "o",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_next_start('@class.outer', 'textobjects')<cr>",
        },
        {
            "O",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_previous_start('@class.outer', 'textobjects')<cr>",
        },

        -- Conditionals
        {
            "i",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_next_start('@conditional.outer', 'textobjects')<cr>",
        },
        {
            "I",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_previous_start('@conditional.outer', 'textobjects')<cr>",
        },

        -- Loops
        {
            "l",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_next_start('@loop.outer', 'textobjects')<cr>",
        },
        {
            "L",
            "<cmd>lua require 'nvim-treesitter.textobjects.move'.goto_previous_start('@loop.outer', 'textobjects')<cr>",
        },
        { "q", nil, { exit = true } },
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>mt", function()
    movement_hydra_hydra:activate()
end, opts)
