local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

-- Setup.
local border_chars_none = { " ", " ", " ", " ", " ", " ", " ", " " }
telescope.setup({
    defaults = {
        mappings = {
            n = {
                ["d"] = require("telescope.actions").delete_buffer,
            },
            i = {
                ["<c-space>"] = require("telescope.actions").to_fuzzy_refine,
            }
        },
        sort_mru = true,
        sorting_strategy = "ascending",
        prompt_prefix = "   ",
        results_title = "",
        path_display = { "truncate" },

        layout_config = {
            prompt_position = "top",
        },
        borderchars = {
            prompt = border_chars_none,
            results = border_chars_none,
            preview = border_chars_none,
        },
    },
    extensions = {
        project = {
            base_dirs = {
                "~/projects",
                "~/.local/share/nvim/lazy",
            },
        },
        live_grep_args = {
            auto_quoting = false,
        },
    },
})

-- Add Extensions
telescope.load_extension "fzf"
telescope.load_extension "project"
telescope.load_extension "live_grep_args"
telescope.load_extension "dap"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)

keymap("n", "<leader>ic", "<cmd>Telescope lsp_incoming_calls<cr>", opts)
keymap("n", "<leader>oc", "<cmd>Telescope lsp_outgoing_calls<cr>", opts)

keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fl", "<cmd>Telescope resume<cr>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope<cr>", opts)
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap(
    "n",
    "<leader>fu",
    "<cmd>lua require'telescope.builtin'.lsp_document_symbols({ symbols = 'function' })<cr>",
    opts
) -- Fuzzy search functions
keymap("n", "<leader>fm", "<cmd>Telescope treesitter<cr>i:macro:<esc>", opts) -- Fuzzy search macros
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", opts) -- see recent files

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
