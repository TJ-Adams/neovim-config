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
                    win = {
                        list = {
                            keys = {
                                ["f"] = "focus_input", -- Map 'f' to start filtering
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
