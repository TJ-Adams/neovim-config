local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

telescope.setup(
    {
        defaults = {
            prompt_prefix = " ",
            selection_caret = "  ",
            path_display = {"smart"}
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

keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fl", "<cmd>Telescope resume<cr>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope<cr>", opts)
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap("n", "<leader>fu", "<cmd>Telescope treesitter<cr>i:function:<esc>", opts) -- Fuzzy search functions
keymap("n", "<leader>fm", "<cmd>Telescope treesitter<cr>i:macro:<esc>", opts) -- Fuzzy search macros

keymap("n", "<leader>fiw", "<cmd>Telescope grep_string<cr>", opts)
keymap("n", "<leader>fib", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
keymap("n", "<leader>fic", "<cmd>Telescope lsp_incoming_calls<cr>", opts)
keymap("n", "<leader>foc", "<cmd>Telescope lsp_outgoing_calls<cr>", opts)

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
