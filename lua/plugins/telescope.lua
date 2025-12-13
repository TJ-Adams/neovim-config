local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local slow_scroll = function(prompt_bufnr, direction)
    local state = require "telescope.state"
    local action_state = require "telescope.actions.state"
    local previewer = action_state.get_current_picker(prompt_bufnr).previewer
    local status = state.get_status(prompt_bufnr)

    -- Check if we actually have a previewer and a preview window
    if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
        return
    end

    previewer:scroll_fn(1 * direction)
end

-- Setup.
telescope.setup({
    defaults = {
        mappings = {
            n = {
                ["d"] = require("telescope.actions").delete_buffer,
                ["r"] = require("telescope.actions").to_fuzzy_refine,
                ["<C-e>"] = function(bufnr)
                    slow_scroll(bufnr, 1)
                end,
                ["<C-y>"] = function(bufnr)
                    slow_scroll(bufnr, -1)
                end,
            },
            i = {
                ["<c-space>"] = require("telescope.actions").to_fuzzy_refine,
                ["<C-e>"] = function(bufnr)
                    slow_scroll(bufnr, 1)
                end,
                ["<C-y>"] = function(bufnr)
                    slow_scroll(bufnr, -1)
                end,
            },
        },
        sort_mru = true,
        sorting_strategy = "ascending",
        prompt_prefix = "   ",
        results_title = "",
        path_display = { "truncate" },

        layout_config = {
            prompt_position = "top",
            height = 0.4,
            width = 0.75,
            preview_width = 0.6,
        },
        layout_strategy = "cursor",
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
        file_browser = {
            display_stat = { date = nil, size = nil, mode = nil },
        },
    },
})

-- Add Extensions
telescope.load_extension "fzf"
telescope.load_extension "project"
telescope.load_extension "live_grep_args"
telescope.load_extension "dap"
telescope.load_extension "file_browser"
telescope.load_extension "tmux"

local keymap = vim.keymap.set

keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go To Definition", silent = true })
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "Go to References", silent = true })
keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Go to Definition of Type", silent = true })

keymap("n", "<leader>ic", "<cmd>Telescope lsp_incoming_calls<cr>", { desc = "See Incoming Calls", silent = true })
keymap("n", "<leader>oc", "<cmd>Telescope lsp_outgoing_calls<cr>", { desc = "See Outgoing Calls", silent = true })

keymap(
    "n",
    "<leader>fg",
    "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
    { desc = "Grep in CWD", silent = true }
)

keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files in CWD", silent = true })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Search Through Open Buffers", silent = true })
keymap("n", "<leader>fl", "<cmd>Telescope resume<cr>", { desc = "Resume Last Telescope Command", silent = true })
keymap("n", "<leader>ft", "<cmd>Telescope<cr>", { desc = "Telescope", silent = true })
keymap(
    "n",
    "<leader>fe",
    "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { desc = "File Explorer at Buffer", silent = true }
)

keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Search Keymaps", silent = true })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Search Help Files", silent = true })
keymap(
    "n",
    "<leader>fu",
    "<cmd>lua require'telescope.builtin'.lsp_document_symbols({ symbols = 'function' })<cr>",
    { desc = "Fuzzy Search Functions", silent = true }
) -- Fuzzy search functions

keymap(
    "n",
    "<leader>fw",
    "<cmd>lua require('telescope').extensions.tmux.switch_window()<cr>",
    { desc = "List tmux windows", silent = true }
)

keymap("n", "<leader>fiw", function()
    local live_grep_args = require("telescope").extensions.live_grep_args
    local word_under_cursor = vim.fn.expand "<cword>"
    local opts = {}

    opts["default_text"] = "\\b" .. word_under_cursor .. "\\b" .. " -i"
    live_grep_args.live_grep_args(opts)
end, { desc = "Grep Word Under Cursor", silent = true })

keymap("n", "<leader>fib", function()
    local live_grep_args = require("telescope").extensions.live_grep_args
    local opts = {}
    local current_buffer = vim.fn.expand "%:p"

    opts["search_dirs"] = { current_buffer }
    live_grep_args.live_grep_args(opts)
end, { desc = "Grep Within Buffer", silent = true })

keymap("n", "<leader>fob", function()
    local live_grep_args = require("telescope").extensions.live_grep_args
    local buffers = {}
    local opts = {}

    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf_id) and vim.bo[buf_id].buflisted then
            table.insert(buffers, vim.fn.expand("#" .. tostring(buf_id) .. ":p"))
        end
    end

    opts["search_dirs"] = buffers
    live_grep_args.live_grep_args(opts)
end, { desc = "Grep Within Open Buffers", silent = true })

keymap(
    "n",
    "<leader>fof",
    "<cmd>lua require'telescope.builtin'.oldfiles()<cr>",
    { desc = "Open Previously Opened Files", silent = true }
)

keymap(
    "n",
    "<leader>fp",
    ":lua require'telescope'.extensions.project.project{}<CR>",
    { desc = "CD to a Project", silent = true }
)

keymap(
    "n",
    "<leader>fnf",
    "<cmd>lua require'telescope.builtin'.find_files({ cwd = require'telescope.utils'.buffer_dir() })<cr>",
    { desc = "Find Files in Buffer Dir", silent = true }
)

keymap("n", "<leader>fng", function()
    local live_grep_args = require("telescope").extensions.live_grep_args
    local current_directory = vim.fn.expand "%:p:h"
    local opts = {}

    opts["search_dirs"] = { current_directory }
    live_grep_args.live_grep_args(opts)
end, { desc = "Grep in Buffer Dir", silent = true })

keymap(
    "n",
    "<leader>fii",
    "<cmd>lua require'telescope.builtin'.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true})<cr>",
    { desc = "Find Files, don't respect .gitignore", silent = true }
)
