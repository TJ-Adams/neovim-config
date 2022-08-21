local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
    return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup(
    {
        view = {
            mappings = {
                custom_only = false,
                list = {
                    {key = {"l", "<CR>"}, cb = tree_cb "edit"},
                    {key = "h", cb = tree_cb "close_node"},
                    {key = "v", cb = tree_cb "vsplit"}
                }
            },
            number = true,
            relativenumber = true
        }
    }
)

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", opts)

-- See default mappings with :help nvim-tree-default-mappings
