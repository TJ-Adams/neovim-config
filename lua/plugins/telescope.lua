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

vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definitions()
end, { desc = "Go To Definition", silent = true })
vim.keymap.set("n", "gr", function()
    require("telescope.builtin").lsp_references()
end, { desc = "Go to References", silent = true })
vim.keymap.set("n", "gi", function()
    require("telescope.builtin").lsp_implementations()
end, { desc = "Go to Implementations", silent = true })
vim.keymap.set("n", "gt", function()
    require("telescope.builtin").lsp_type_definitions()
end, { desc = "Go to Definition of Type", silent = true })

vim.keymap.set("n", "<leader>ic", function()
    require("telescope.builtin").lsp_incoming_calls()
end, { desc = "See Incoming Calls", silent = true })
vim.keymap.set("n", "<leader>oc", function()
    require("telescope.builtin").lsp_outgoing_calls()
end, { desc = "See Outgoing Calls", silent = true })

vim.keymap.set("n", "<leader>fg", function()
    require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Grep in CWD", silent = true })

vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
end, { desc = "Find Files in CWD", silent = true })
vim.keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, { desc = "Search Through Open Buffers", silent = true })
vim.keymap.set("n", "<leader>fl", function()
    require("telescope.builtin").resume()
end, { desc = "Resume Last Telescope Command", silent = true })
vim.keymap.set("n", "<leader>ft", function()
    require("telescope.builtin").builtin({ include_extensions = true })
end, { desc = "Telescope", silent = true })
vim.keymap.set("n", "<leader>fe", function()
    local buffer_path = vim.fn.expand "%:p:h"
    require("telescope").extensions.file_browser.file_browser({ path = buffer_path })
end, { desc = "File Explorer at Buffer", silent = true })

vim.keymap.set("n", "<leader>fk", function()
    require("telescope.builtin").keymaps()
end, { desc = "Search Keymaps", silent = true })
vim.keymap.set("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
end, { desc = "Search Help Files", silent = true })
vim.keymap.set("n", "<leader>fs", function()
    require("telescope.builtin").lsp_document_symbols()
end, { desc = "Fuzzy Search Functions", silent = true }) -- Fuzzy search symbols

vim.keymap.set("n", "<leader>fw", "<cmd>Telescope tmux windows<cr>", { desc = "List tmux windows", silent = true })

vim.keymap.set("n", "<leader>fiw", function()
    local live_grep_args = require("telescope").extensions.live_grep_args
    local word_under_cursor = vim.fn.expand "<cword>"
    local opts = {}

    opts["default_text"] = "\\b" .. word_under_cursor .. "\\b" .. " -i"
    live_grep_args.live_grep_args(opts)
end, { desc = "Grep Word Under Cursor", silent = true })

-- Grep the contents of buffers with live_grep_args.
--
-- ripgrep only reads files, so a buffer with nothing on disk -- a terminal
-- (an AI tool's conversation, say), a scratch buffer -- used to give no
-- results. Snapshot those into temp files for ripgrep to search, and point
-- each hit back at the buffer: selecting it jumps to that buffer and line, and
-- the previewer shows the buffer's own lines. Buffers backed by a file are
-- grepped on disk, as before. The snapshots live in Neovim's temp dir, which
-- is removed on exit.
local function grep_buffers(bufs)
    local tmpdir = vim.fn.tempname()
    vim.fn.mkdir(tmpdir, "p")

    local search_dirs, snapshot_buf = {}, {}
    for _, buf in ipairs(bufs) do
        local name = vim.api.nvim_buf_get_name(buf)
        if vim.bo[buf].buftype == "" and name ~= "" and vim.uv.fs_stat(name) then
            table.insert(search_dirs, name)
        else
            local snapshot = tmpdir .. "/" .. buf
            vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), snapshot)
            table.insert(search_dirs, snapshot)
            snapshot_buf[snapshot] = buf
        end
    end

    -- What a snapshot hit shows instead of its temp path.
    local function label(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        if vim.bo[buf].buftype == "terminal" then
            -- A name given with :file (<leader>tn), as <leader>fb shows it.
            if not vim.startswith(name, "term://") then
                return "[term] " .. vim.fn.fnamemodify(name, ":~:.")
            end
            -- Else the title the program set. Until it sets one, Neovim uses
            -- the buffer name, term://{cwd}//{pid}:{cmd}, so show the {cmd}.
            local title = vim.b[buf].term_title or name
            return "[term] " .. (title:match "^term://.-//%d+:(.*)$" or title)
        end
        return name ~= "" and name or ("[No Name " .. buf .. "]")
    end

    local opts = { search_dirs = search_dirs }
    local make_entry = require("telescope.make_entry").gen_from_vimgrep(opts)
    opts.entry_maker = function(line)
        local entry = make_entry(line)
        local buf = entry and snapshot_buf[entry.filename]
        if buf then
            entry.bufnr = buf
            entry.filename = label(buf)
        end
        return entry
    end

    require("telescope").extensions.live_grep_args.live_grep_args(opts)
end

vim.keymap.set("n", "<leader>fib", function()
    grep_buffers({ vim.api.nvim_get_current_buf() })
end, { desc = "Grep Within Buffer", silent = true })

vim.keymap.set("n", "<leader>fob", function()
    local bufs = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
    end, vim.api.nvim_list_bufs())
    grep_buffers(bufs)
end, { desc = "Grep Within Open Buffers", silent = true })

vim.keymap.set("n", "<leader>fof", function()
    require("telescope.builtin").oldfiles()
end, { desc = "Open Previously Opened Files", silent = true })

vim.keymap.set("n", "<leader>fp", function()
    require("telescope").extensions.project.project({})
end, { desc = "CD to a Project", silent = true })

vim.keymap.set("n", "<leader>fnf", function()
    require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() })
end, { desc = "Find Files in Buffer Dir", silent = true })

vim.keymap.set("n", "<leader>fng", function()
    local live_grep_args = require("telescope").extensions.live_grep_args
    local current_directory = vim.fn.expand "%:p:h"
    local opts = {}

    opts["search_dirs"] = { current_directory }
    live_grep_args.live_grep_args(opts)
end, { desc = "Grep in Buffer Dir", silent = true })

vim.keymap.set("n", "<leader>fii", function()
    require("telescope.builtin").find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
end, { desc = "Find Files, don't respect .gitignore", silent = true })

-- Setup.
return {
    {
        "nvim-telescope/telescope.nvim",
        opts = {
            defaults = {
                mappings = {
                    n = {
                        ["d"] = require("telescope.actions").delete_buffer,
                        ["r"] = require("telescope.actions").to_fuzzy_refine,
                        ["<C-q>"] = require("telescope.actions").smart_send_to_qflist
                            + require("telescope.actions").open_qflist,
                        ["<C-e>"] = function(bufnr)
                            slow_scroll(bufnr, 1)
                        end,
                        ["<C-y>"] = function(bufnr)
                            slow_scroll(bufnr, -1)
                        end,
                    },
                    i = {
                        ["<C-q>"] = require("telescope.actions").smart_send_to_qflist
                            + require("telescope.actions").open_qflist,
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
                    cursor = {
                        preview_width = 0.6,
                    },
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
        },
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension "live_grep_args"
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension "fzf"
            -- Regex terms (\b, \w, ...) in the fuzzy pickers, on top of fzf.
            require("core.telescope_regex").setup()
        end,
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    {
        "https://github.com/nvim-telescope/telescope-project.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension "project"
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").load_extension "file_browser"
        end,
    },
    {
        "camgraff/telescope-tmux.nvim",
    },
}
