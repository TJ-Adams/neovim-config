-- Bootstraps and Downloads lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    return
end

local plugins_path = os.getenv "HOME" .. "/.config/nvim/lua/plugins/"
local dap_path = os.getenv "HOME" .. "/.config/nvim/lua/dap-config/"

local plugins = {
    -- Colorscheme Plugins
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            dofile(plugins_path .. "gruvbox.lua")
        end,
    },

    -- Start Screen Plugin
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        opts = function()
            local dashboard = require "alpha.themes.dashboard"
            local function get_current_directory()
                local file_path = os.getenv "PWD"
                local current_dir_limit = 0
                local str_length = string.len(file_path)

                -- Parse backwards and find the first '/'
                for i = str_length, 1, -1 do
                    local char = string.sub(file_path, i, i)
                    if char == "/" then
                        current_dir_limit = i
                        break
                    end
                end

                local current_dir = string.sub(file_path, current_dir_limit + 1)

                return current_dir
            end

            local current_dir = get_current_directory()
            if current_dir == "" then
                current_dir = "root"
            end
            local font_path = os.getenv "HOME" .. "/.config/nvim/media/ansi_shadow.flf"
            local handle = io.popen("figlet -f " .. font_path .. " -w 200" .. " " .. current_dir)

            local logo = handle:read "*a"

            local TOP_PADDING = 2
            dashboard.section.header.val = vim.split(logo, "\n")
            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
                dashboard.button("p", " " .. " Open project", ":Telescope project<CR>"),
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
                dashboard.button("t", " " .. " Terminal", ":terminal<CR>"),
                dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
                dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":q<CR>"),
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end
            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"
            dashboard.opts.layout[1].val = TOP_PADDING
            return dashboard
        end,
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },

    -- Telescope & Extensions
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            dofile(plugins_path .. "telescope.lua")
        end,
    },
    {
        "mrjones2014/tldr.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            dofile(plugins_path .. "tldr.lua")
        end,
        keys = {
            { "<leader>fd", desc = "Go through tldr pages" },
        },
    },
    {
        "https://github.com/nvim-telescope/telescope-project.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },

    -- Project Based Notes
    {
        "RutaTang/quicknote.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            dofile(plugins_path .. "quicknote.lua")
        end,
    },

    -- Neorg & Extensions
    {
        "nvim-neorg/neorg",
        ft = "norg",
        config = function()
            dofile(plugins_path .. "neorg.lua")
        end,
        keys = {
            { "<leader>njt", desc = "Neorg Journal Today" },
        },
    },
    {
        "nvim-neorg/neorg-telescope",
        ft = "norg",
        dependencies = {
            "nvim-neorg/neorg",
        },
    },

    -- File Explorer
    {
        "kyazdani42/nvim-tree.lua",
        config = function()
            dofile(plugins_path .. "nvim-tree.lua")
        end,
        keys = {
            { "<leader>e", desc = "Toggle File Explorer" },
        },
    },

    -- Git Integration
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            dofile(plugins_path .. "gitsigns.lua")
        end,
    },
    { "tpope/vim-fugitive" },

    -- Diff viewer
    {
        "sindrets/diffview.nvim",
        config = true,
    },

    -- Resolving Git Conflicts
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = function()
            dofile(plugins_path .. "git-conflict.lua")
        end,
    },

    -- Lazy Git Usage
    {
        "kdheepak/lazygit.nvim",
        config = function()
            dofile(plugins_path .. "lazygit.lua")
        end,
        keys = {
            { "<leader>lg", desc = "lazygit" },
            { "<leader>lb", desc = "Commits in current buffer" },
        },
    },

    -- Status Line
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            dofile(plugins_path .. "lualine.lua")
        end,
    },

    -- Hydra
    {
        "anuvyklack/hydra.nvim",
        config = function()
            dofile(plugins_path .. "hydra.lua")
        end,
    },

    -- Quick Movements
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function()
            dofile(plugins_path .. "flash.lua")
        end,
    },

    -- Nice Folds
    {
        "kevinhwang91/nvim-ufo",
        config = function()
            dofile(plugins_path .. "nvim-ufo.lua")
        end,
    },

    -- Erase Trailing White Space
    { "lewis6991/spaceless.nvim" },

    -- LSP Plugins
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
    },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "ray-x/lsp_signature.nvim" },

    -- DAP Plugins
    { "mfussenegger/nvim-dap" },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            dofile(dap_path .. "../dap-config/nvim-dap-ui.lua")
        end,
        keys = {
            { "<leader>du", desc = "Toggle DAP UI" },
        },
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    { "jbyuki/one-small-step-for-vimkind" },

    -- Show definition in floating preview window
    {
        "rmagatti/goto-preview",
        config = function()
            dofile(plugins_path .. "goto-preview.lua")
        end,
    },

    -- Show buffers like web browser tabs
    {
        "akinsho/bufferline.nvim",
        config = function()
            dofile(plugins_path .. "bufferline.lua")
        end,
    },

    -- Treesitter Highlighting and Plugins
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            dofile(plugins_path .. "nvim-treesitter.lua")
        end,
    },
    {
        "nvim-treesitter/playground",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            dofile(plugins_path .. "nvim-treesitter-context.lua")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            dofile(plugins_path .. "nvim-treesitter-textobjects.lua")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },

    -- Aerial for outline of file
    {
        "stevearc/aerial.nvim",
        config = function()
            dofile(plugins_path .. "aerial.lua")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>ah", desc = "Toggle Aerial Left Side Panel" },
            { "<leader>al", desc = "Toggle Aerial Right Side Panel" },
            { "<leader>an", desc = "Aerial Navigation Toggle" },
            { "{", desc = "AerialPrev" },
            { "}", desc = "AerialNext" },
            { "[[", desc = "Aerial prev_up" },
            { "]]", desc = "Aerial next_up" },
        },
    },

    -- UI Changes
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
        "mrjones2014/smart-splits.nvim",
        config = function()
            dofile(plugins_path .. "smart-splits.lua")
        end,
    },

    -- todo comments
    -- NOTE: Using my fork until my change gets merged or
    --       maintainer adds ability to turn off highlight
    --       overrides without breaking other features.
    {
        "tj-adams/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
        },
        config = function()
            dofile(plugins_path .. "todo-comments.lua")
        end,
        keys = { "<leader>xt" },
    },

    -- Trouble
    {
        "folke/trouble.nvim",
        config = function()
            dofile(plugins_path .. "trouble.lua")
        end,
        keys = {
            { "<leader>xx" },
            { "<leader>xd" },
            { "<leader>xw" },
        },
    },

    -- Marks that you can Name
    {
        "crusj/bookmarks.nvim",
        branch = "main",
        dependencies = { "nvim-web-devicons" },
        config = function()
            dofile(plugins_path .. "bookmarks.lua")
        end,
    },

    -- Spectre (Search and Replace)
    {
        "nvim-pack/nvim-spectre",
        config = true,
    },

    -- Overseer to manage tasks
    {
        "stevearc/overseer.nvim",
        config = function()
            dofile(plugins_path .. "overseer.lua")
        end,
    },

    -- Built in Terminal into Vim
    {
        "akinsho/toggleterm.nvim",
        config = function()
            dofile(plugins_path .. "toggleterm.lua")
        end,
        keys = {
            { "<leader>tt", desc = "Toggles Terminal" },
        },
    },

    -- Tmux Navigation
    {
        "alexghergh/nvim-tmux-navigation",
        config = function()
            dofile(plugins_path .. "nvim-tmux-navigation.lua")
        end,
    },

    -- Cool Notifications
    {
        "folke/noice.nvim",
        config = function()
            dofile(plugins_path .. "noice.lua")
        end,
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },

    -- Help remember keymaps
    {
        "folke/which-key.nvim",
        config = function()
            dofile(plugins_path .. "which-key.lua")
        end,
    },

    -- Improved highlighting for searching
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            dofile(plugins_path .. "nvim-hlslens.lua")
        end,
        keys = {
            { "/" },
            { "*" },
        },
    },

    -- Underline word under cursor & Smoother scrolling
    { "echasnovski/mini.cursorword", version = "*", config = true },
    {
        "echasnovski/mini.animate",
        version = "*",
        config = function()
            dofile(plugins_path .. "mini-animate.lua")
        end,
    },

    -- Auto Pairs
    {
        "windwp/nvim-autopairs",
        config = true,
        dependencies = {
            "kevinhwang91/promise-async",
        },
    },

    -- Surround plugin
    { "kylechui/nvim-surround", config = true },

    -- Persistent Sessions
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
        -- stylua: ignore
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
        },
    },

    -- AI Plugins
    {
        "jackMort/ChatGPT.nvim",
        config = function()
            dofile(plugins_path .. "chatgpt.lua")
        end,

        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },

        keys = {
            { "<leader>ch", desc = "ChatGPT" },
        },
    },
}

local lazy_nvim_opts = {
    git = {
        -- Avoid partial clones so I have git history even offline
        filter = false,
    },
}

lazy.setup(plugins, lazy_nvim_opts)

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts)
