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

-- Put the cursor on `path`, or on the nearest ancestor directory that's
-- still in the list. Walking up keeps the cursor near where it was when a
-- filter hides the item it was on, instead of dropping it at the root.
local function reveal_nearest(picker, path)
    local reveal = require("snacks.explorer.actions").reveal
    while path and path ~= "" do
        if reveal(picker, path) then
            return true
        end
        local parent = vim.fs.dirname(path)
        path = parent ~= path and parent or nil
    end
end

-- Path of `file` relative to nvim's cwd. Both sides are resolved first: the
-- explorer always hands out absolute paths, and cwd may be a symlinked
-- project dir while the item came in resolved (or the other way around),
-- which would otherwise leave the "relative" path absolute. Same approach as
-- `<leader>yr` in core/keymaps.lua.
local function relative_path(file)
    file = vim.fn.resolve(file)
    local cwd = vim.fn.resolve(vim.fn.getcwd())
    if file:sub(1, #cwd + 1) == cwd .. "/" then
        return file:sub(#cwd + 2)
    end
    return vim.fn.fnamemodify(file, ":.") -- fall back to Vim's relativizer
end

-- Yank the path of every selected item (or the one under the cursor),
-- one per line, after running each through `modify`. Mirrors snacks' own
-- `explorer_yank`, which only ever yanks absolute paths.
local function yank_paths(picker, modify)
    local paths = {}
    if vim.fn.mode():find("^[vV]") then
        picker.list:select()
    end
    for _, item in ipairs(picker:selected({ fallback = true })) do
        paths[#paths + 1] = modify(Snacks.picker.util.path(item))
    end
    picker.list:set_selected() -- clear selection
    -- Honor an explicit register prefix (`"ayr`), but default to the
    -- clipboard rather than the unnamed register.
    local reg = vim.v.register
    if reg == "" or reg == '"' then
        reg = "+"
    end
    vim.fn.setreg(reg, table.concat(paths, "\n"), #paths > 1 and "l" or "c")
    Snacks.notify.info("Yanked " .. #paths .. (#paths == 1 and " path" or " paths"))
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
                    -- filter is on. Snacks also derives a `toggle_buffers_only`
                    -- action from this, but it restores the cursor by row
                    -- number, so `b` uses the action below instead.
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
                                ["b"] = "explorer_buffers_only",
                                -- Disable keymaps in favor or default behavior
                                ["/"] = false,
                                ["?"] = false,
                                -- Open via a window picker (see actions below).
                                -- Can't override `confirm` directly: the explorer
                                -- source's setup() re-merges the default confirm on
                                -- top, so we point the keys at a new action instead.
                                ["l"] = "pick_win_confirm",
                                ["<CR>"] = "pick_win_confirm",
                                -- Yank paths: `ya` absolute, `yr` relative
                                -- to cwd. Plain `y` (absolute) is dropped so
                                -- neither has to wait out 'timeoutlen'.
                                ["y"] = false,
                                ["ya"] = { "explorer_yank_absolute", mode = { "n", "x" } },
                                ["yr"] = { "explorer_yank_relative", mode = { "n", "x" } },
                            },
                        },
                        input = {
                            keys = {
                                ["<CR>"] = { "pick_win_confirm", mode = { "n", "i" } },
                            },
                        },
                    },
                    actions = {
                        -- Toggle the buffers-only filter, keeping the cursor on
                        -- a sensible item. The `toggle_buffers_only` action
                        -- snacks generates from `toggles` can't be overridden
                        -- (it's assigned after this table is merged) and only
                        -- restores the cursor row, which points at an unrelated
                        -- file once the item list changes.
                        explorer_buffers_only = function(picker)
                            local opts = picker.opts
                            local current = picker:current()
                            local cursor = current and current.file

                            -- Watch for cursor movement while the filter is on.
                            -- Comparing the item under the cursor at toggle
                            -- time isn't enough on its own: navigating to the
                            -- item the filter happened to leave the cursor on
                            -- looks identical to never having moved.
                            if not opts.buffers_only_hooked then
                                opts.buffers_only_hooked = true
                                picker.list.win:on("CursorMoved", function()
                                    local item = not picker.closed and opts.buffers_only and picker:current()
                                    if item and item.file ~= opts.buffers_only_landed then
                                        opts.buffers_only_moved = true
                                    end
                                end, { buf = true })
                            end

                            if opts.buffers_only then
                                -- Turning off: go back to the item the cursor
                                -- was on before filtering, unless it was moved
                                -- while the filter was on. Either signal counts
                                -- as a move: sitting on a different item than
                                -- the filter left us on, or a cursor movement
                                -- that came back to it.
                                local moved = opts.buffers_only_moved or cursor ~= opts.buffers_only_landed
                                local target = not moved and opts.buffers_only_cursor or cursor
                                opts.buffers_only = false
                                opts.buffers_only_cursor, opts.buffers_only_landed = nil, nil
                                opts.buffers_only_moved = nil
                                picker:find({
                                    on_done = function()
                                        if target then
                                            reveal_nearest(picker, target)
                                        end
                                    end,
                                })
                            else
                                opts.buffers_only = true
                                opts.buffers_only_cursor = cursor
                                opts.buffers_only_moved = false
                                picker:find({
                                    on_done = function()
                                        -- Stay put if the item survived the
                                        -- filter, then record where the cursor
                                        -- ended up: moving off that item is
                                        -- what counts as moving.
                                        if cursor then
                                            reveal_nearest(picker, cursor)
                                        end
                                        local landed = picker:current()
                                        opts.buffers_only_landed = landed and landed.file
                                    end,
                                })
                            end
                        end,

                        explorer_yank_absolute = function(picker)
                            yank_paths(picker, function(path)
                                return path
                            end)
                        end,

                        explorer_yank_relative = function(picker)
                            yank_paths(picker, relative_path)
                        end,

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
