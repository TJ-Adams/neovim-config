return {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        { "<leader>lc", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },
        {
            "<leader>lr",
            function()
                require("telescope").extensions.lazygit.lazygit()
            end,
            desc = "LazyGit Search",
        },
    },
    config = function()
        require("telescope").load_extension "lazygit"

        -- Project root detection logic
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
                require("lazygit.utils").project_root_dir()
            end,
        })

        -- 3. Terminal-specific keymaps
        vim.api.nvim_create_autocmd("TermEnter", {
            pattern = "term://*lazygit*",
            callback = function()
                local opts = { buffer = 0 }
                -- Prevents Neovim from intercepting these keys so they go to LazyGit
                vim.keymap.set("t", "<esc>", "<esc>", opts)
                vim.keymap.set("t", "<C-j>", "<C-j>", opts)
                vim.keymap.set("t", "<C-k>", "<C-k>", opts)
                vim.keymap.set("t", "<C-h>", "<C-h>", opts)
                vim.keymap.set("t", "<C-l>", "<C-l>", opts)
            end,
        })
    end,
}
