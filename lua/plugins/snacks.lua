-- Absolute paths of every listed buffer that maps to a real file.
local function buffer_files()
    local ret = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted then
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" and vim.fn.filereadable(name) == 1 then
                ret[#ret + 1] = vim.fs.normalize(name)
            end
        end
    end
    return ret
end

-- Paths the explorer may show while the buffers-only filter is on: the
-- buffers themselves plus every directory leading to one (and the root).
local function buffer_paths(cwd)
    local keep = { [cwd] = true }
    for _, file in ipairs(buffer_files()) do
        if file:sub(1, #cwd + 1) == cwd .. "/" then
            keep[file] = true
            for dir in Snacks.picker.util.parents(file, cwd) do
                keep[dir] = true
            end
        end
    end
    return keep
end

return {
    "folke/snacks.nvim",
    dependencies = {
        { "nvim-mini/mini.nvim", version = "*" },
        { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {
        input = {},
        styles = {
            input = {
                relative = "cursor",
            },
        },
        explorer = {
            -- don't use system trash when deleting files
            trash = false,
        },
        picker = {
            sources = {
                explorer = {
                    -- Show a `b` flag in the title while the buffers-only
                    -- filter is on. Snacks derives a `toggle_buffers_only`
                    -- action from every entry here, so this also creates the
                    -- action the keymap below uses.
                    toggles = { buffers_only = "b" },

                    -- Expand the directories leading to each open buffer
                    -- before the tree is built, so buffers sitting inside
                    -- collapsed directories still show up. Runs on every
                    -- find, so buffers opened later get picked up too.
                    finder = function(opts, ctx)
                        local Tree = require("snacks.explorer.tree")
                        local cwd = ctx.filter.cwd
                        if opts.buffers_only then
                            if not opts.buffers_only_state then
                                -- remember the expansion state, so toggling
                                -- the filter back off can restore it
                                local open = {}
                                Tree:walk(Tree:find(cwd), function(node)
                                    open[node.path] = node.open
                                end, { all = true })
                                opts.buffers_only_state = { cwd = cwd, open = open }
                            end
                            -- The finder runs synchronously, the transform
                            -- below doesn't, so collect the paths here:
                            -- buffer APIs are off limits in a fast event.
                            local keep = buffer_paths(cwd)
                            ctx.meta.buffers_only_keep = keep
                            for path in pairs(keep) do
                                Tree:open(path)
                            end
                        elseif opts.buffers_only_state then
                            local state = opts.buffers_only_state
                            opts.buffers_only_state = nil
                            if state.cwd == cwd then
                                Tree:walk(Tree:find(cwd), function(node)
                                    if node.dir and node.open and node.path ~= cwd and not state.open[node.path] then
                                        Tree:close(node.path)
                                    end
                                end, { all = true })
                            end
                        end
                        return require("snacks.picker.source.explorer").explorer(opts, ctx)
                    end,

                    -- Drop every item that isn't an open buffer or a
                    -- directory on the way to one. `buffers_only_keep` is
                    -- only set while the filter is on.
                    transform = function(item, ctx)
                        local keep = ctx.meta.buffers_only_keep
                        if keep and not keep[item.file] then
                            return false
                        end
                    end,

                    win = {
                        list = {
                            keys = {
                                ["f"] = "focus_input", -- Map 'f' to start filtering
                                -- Filter the tree down to open buffers.
                                ["b"] = "toggle_buffers_only",
                                -- Disable keymaps in favor or default behavior
                                ["/"] = false,
                                ["?"] = false,
                                -- Open via a window picker (see actions below).
                                -- Can't override `confirm` directly: the explorer
                                -- source's setup() re-merges the default confirm on
                                -- top, so we point the keys at a new action instead.
                                ["l"] = "pick_win_confirm",
                                ["<CR>"] = "pick_win_confirm",
                            },
                        },
                        input = {
                            keys = {
                                ["<CR>"] = { "pick_win_confirm", mode = { "n", "i" } },
                            },
                        },
                    },
                    actions = {
                        -- When opening a file, if more than one editor split is
                        -- open, prompt for which split to open it in. With a
                        -- single split, pick_win returns it without prompting.
                        pick_win_confirm = function(picker, item, action)
                            local explorer = require("snacks.explorer.actions")
                            if item and not item.dir and not picker.input.filter.meta.searching then
                                local win = Snacks.picker.util.pick_win({ main = picker.main })
                                if not win then
                                    return -- cancelled the window pick
                                end
                                picker.main = win
                            end
                            explorer.actions.confirm(picker, item, action)
                        end,
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader>e",
            function()
                require("snacks").explorer.reveal()
            end,
        },
    },
}
