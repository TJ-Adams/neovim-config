-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil and client:supports_method "textDocument/foldingRange" then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
    end,
})

-- Enable Tree Sitter Syntax Highlighting
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
        },
        branch = "main",
        build = 'TSUpdate',
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            enable = false,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        branch = "main",
        opts = {
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
        },
    },
}
