vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>")

local function on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- Custom Mappings
    vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts "Open")
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
    vim.keymap.set("n", "v", api.node.open.vertical, opts "Open: Vertical Split")
end

return {
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            on_attach = on_attach,
            view = {
                number = true,
                relativenumber = true,
                adaptive_size = true,
            },
            renderer = {
                symlink_destination = false,
                highlight_opened_files = "all",
            },

            -- open file explorer at the file even outside of cwd
            update_focused_file = {
                enable = true,
                update_root = {
                    enable = true,
                },
            },
        },
    },
}
