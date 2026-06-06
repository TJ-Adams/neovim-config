-- When completing a path, only keep items whose basename is a prefix of what's
-- being typed, so `~/.conf` completes `~/.config/` directly instead of offering
-- fuzzy matches like `.tmux.conf`. Falls back to all items when nothing is a
-- prefix match, so fuzzy matching still helps when there's no clean hit.
--
-- Applied to both the `path` source (insert mode) and the `cmdline` source,
-- which is what `:edit <Tab>` actually uses. For non-path cmdline completion
-- (commands, options, ...) getcompletion() already returns prefix matches, so
-- this is a no-op there.
local function prefer_prefix_matches(ctx, items)
    local query = ctx.line:sub(1, ctx.cursor[2]):match("[^/\\ ]+$") or ""
    if query == "" then return items end
    local lower_query = query:lower()
    local prefix_matches = vim.tbl_filter(function(item)
        local label = (item.filterText or item.label):lower()
        if label:sub(-1) == "/" then label = label:sub(1, -2) end
        return label:sub(1, #lower_query) == lower_query
    end, items)
    return #prefix_matches > 0 and prefix_matches or items
end

-- By default blink fetches once (e.g. when you type `.`) and then fuzzy-filters
-- that cached list as you keep typing forward, which means `transform_items`
-- never re-runs with the full query. Forcing `is_incomplete_forward` makes blink
-- re-fetch on every forward keystroke so `prefer_prefix_matches` runs against the
-- complete query each time.
local function refetch_on_forward(module, context, callback)
    return module:get_completions(context, function(response)
        if response then response.is_incomplete_forward = true end
        callback(response)
    end)
end

return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",

    opts = {
        keymap = {
            preset = "enter",
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        },

        completion = { documentation = { auto_show = true }, list = { selection = { preselect = false } } },
        cmdline = {
            keymap = {
                preset = "super-tab",
                ["<Tab>"] = {
                    -- Menu closed: if the candidates have filtered down to a single
                    -- match, fill it outright (terminal-style) instead of popping a
                    -- one-item menu; otherwise open the menu. If the menu is already
                    -- open, fall through to the next mapping to accept the selection.
                    function(cmp)
                        if cmp.is_visible() then return end
                        local list = require("blink.cmp.completion.list")
                        if #list.items == 1 then
                            vim.schedule(function() list.accept({ index = 1 }) end)
                            return true
                        end
                        return cmp.show({
                            callback = function()
                                if #list.items == 1 then list.accept({ index = 1 }) end
                            end,
                        })
                    end,
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
            },
            completion = { menu = { auto_show = false }, list = { selection = { preselect = false } } },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            per_filetype = {
                markdown = {
                    "lsp",
                    "path",
                    "snippets",
                },
                norg = {
                    "path",
                },
            },
            providers = {
                path = {
                    transform_items = prefer_prefix_matches,
                    override = { get_completions = refetch_on_forward },
                },
                cmdline = {
                    transform_items = prefer_prefix_matches,
                    override = { get_completions = refetch_on_forward },
                },
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    main = "blink.cmp",
    opts_extend = { "sources.default" },
}
