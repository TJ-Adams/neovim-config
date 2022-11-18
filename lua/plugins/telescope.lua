local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

telescope.setup(
    {
        defaults = {
            prompt_prefix = " ",
            selection_caret = "  ",
            path_display = {"truncate"}
        },
        pickers = {},
        extensions = {
            project = {
                base_dirs = {
                    "~/projects"
                },
                theme = "dropdown"
            }
        }
    }
)

-- Add Extensions
telescope.load_extension('fzf')
telescope.load_extension('project')
telescope.load_extension('live_grep_args')

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)

keymap("n", "<leader>ic", "<cmd>Telescope lsp_incoming_calls<cr>", opts)
keymap("n", "<leader>oc", "<cmd>Telescope lsp_outgoing_calls<cr>", opts)

keymap("n", "<leader>fd", "<cmd>Telescope tldr<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fl", "<cmd>Telescope resume<cr>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope<cr>", opts)
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap("n", "<leader>fu", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols({ symbols = 'function' })<cr>", opts) -- Fuzzy search functions
keymap("n", "<leader>fm", "<cmd>Telescope treesitter<cr>i:macro:<esc>", opts) -- Fuzzy search macros

keymap("n", "<leader>fiw", "<cmd>Telescope grep_string<cr>", opts)
keymap("n", "<leader>fib", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)

keymap("n", "<leader>fp", ":lua require'telescope'.extensions.project.project{}<CR>", opts)

keymap(
    "n",
    "<leader>fc",
    "<cmd>lua require'telescope.builtin'.find_files({ cwd = require'telescope.utils'.buffer_dir() })<cr>",
    opts
)
keymap(
    "n",
    "<leader>fii",
    "<cmd>lua require'telescope.builtin'.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true})<cr>",
    opts
)
