return {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        -- This is useful for managing submodules without changing
        -- the current working directory
        require("telescope").load_extension "lazygit"

        vim.keymap.set("n", "<leader>lg", "<cmd>:LazyGit<cr>")
        vim.keymap.set("n", "<leader>lc", "<cmd>:LazyGitFilter<cr>")
        vim.keymap.set("n", "<leader>lr", "<cmd>:lua require('telescope').extensions.lazygit.lazygit()<cr>")

        vim.cmd [[ autocmd BufEnter * :lua require('lazygit.utils').project_root_dir() ]]

        -- Ensure lazygit recieves the escape key
        function _G.set_lazygit_keymaps()
            local lazygit_opts = { buffer = 0 }

            vim.keymap.set("t", "<esc>", "<esc>", lazygit_opts)

            vim.keymap.set("t", "<C-j>", "<C-j>", lazygit_opts)
            vim.keymap.set("t", "<C-k>", "<C-k>", lazygit_opts)
            vim.keymap.set("t", "<C-h>", "<C-h>", lazygit_opts)
            vim.keymap.set("t", "<C-l>", "<C-l>", lazygit_opts)
        end

        vim.cmd "autocmd! TermEnter term://*lazygit* lua set_lazygit_keymaps()"
    end,
}
