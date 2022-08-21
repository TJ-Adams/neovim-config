local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

-- This is useful for managing submodules without changing
-- the current working directory
telescope.load_extension("lazygit")

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>lg", "<cmd>:LazyGit<cr>", opts)
keymap("n", "<leader>lc", "<cmd>:LazyGitFilter<cr>", opts)
keymap("n", "<leader>lb", "<cmd>:LazyGitFilterCurrentFile<cr>", opts)
keymap("n", "<leader>lr", "<cmd>:lua require('telescope').extensions.lazygit.lazygit()<cr>", opts)

vim.cmd([[ autocmd BufEnter * :lua require('lazygit.utils').project_root_dir() ]])
