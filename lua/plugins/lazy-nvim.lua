-- Bootstraps and Downloads lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

local plugins_path = os.getenv("HOME") .. "/.config/nvim/lua/plugins/"


lazy.setup({
    -- Colorscheme Plugins
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            dofile(plugins_path .. "gruvbox.lua")
        end,
    },

    -- Telescope & Extensions
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function ()
            dofile(plugins_path .. "telescope.lua")
        end,
    },
    {
        "mrjones2014/tldr.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function ()
            dofile(plugins_path .. "tldr.lua")
        end,
        keys = {
            { "<leader>fd", desc = "Go through tldr pages"},
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

    -- Neorg & Extensions
    {
        "nvim-neorg/neorg",
        ft = "norg",
        config = function ()
            dofile(plugins_path .. "neorg.lua")
        end,
        keys = {
            { "<leader>njt", desc = "Neorg Journal Today"},
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
        config = function ()
            dofile(plugins_path .. "nvim-tree.lua")
        end,
        keys = {
            { "<leader>e", desc = "Toggle File Explorer"},
        },
    },

    -- Git Integration
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            dofile(plugins_path .. "gitsigns.lua")
        end
    },
    {"tpope/vim-fugitive"},

    -- Lazy Git Usage
    {
        "kdheepak/lazygit.nvim",
        config = function ()
            dofile(plugins_path .. "lazygit.lua")
        end,
        keys = {
            { "<leader>lg", desc = "lazygit"},
            { "<leader>lb", desc = "Commits in current buffer"},
        },
    },

    -- Status Line
    {
        "nvim-lualine/lualine.nvim",
        config = function ()
            dofile(plugins_path .. "lualine.lua")
        end
    },

    -- Quick Movements
    {"ggandor/lightspeed.nvim"},

    -- Nice Folds
    {
        "kevinhwang91/nvim-ufo",
        config = function ()
            dofile(plugins_path .. "nvim-ufo.lua")
        end
    },

    -- LSP Plugins
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
    },
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
    {"hrsh7th/nvim-cmp"},
    {"L3MON4D3/LuaSnip"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"ray-x/lsp_signature.nvim"},

    -- Show definition in floating preview window
    {
        "rmagatti/goto-preview",
        config = function ()
            dofile(plugins_path .. "goto-preview.lua")
        end
    },

    -- Show buffers like web browser tabs
    {
         "akinsho/bufferline.nvim",
        config = function ()
            dofile(plugins_path .. "bufferline.lua")
        end
    },

    -- Treesitter Highlighting and Plugins
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            dofile(plugins_path .. "nvim-treesitter.lua")
        end
    },
    {
        "nvim-treesitter/playground",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        }
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function ()
            dofile(plugins_path .. "nvim-treesitter-context.lua")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        }
    },

    -- Aerial for outline of file
    {
        "stevearc/aerial.nvim",
        config = function ()
            dofile(plugins_path .. "aerial.lua")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>aa", desc = "Toggle Aerial Side Panel"},
            { "<leader>an", desc = "Aerial Navigation Toggle"},
            { "{", desc = "AerialPrev"},
            { "}", desc = "AerialNext"},
            { "[[", desc = "Aerial prev_up"},
            { "]]", desc = "Aerial next_up"},
        },
    },

    -- Trouble
    {
        "folke/trouble.nvim",
        config = function ()
            dofile(plugins_path .. "trouble.lua")
        end,
        keys = {
            {"<leader>xx"},
            {"<leader>xd"},
            {"<leader>xw"},
        }
    },

    -- Built in Terminal into Vim
    {
         "akinsho/toggleterm.nvim",
        config = function ()
            dofile(plugins_path .. "toggleterm.lua")
        end,
        keys = {
            { "<leader>tt", desc = "Toggles Terminal"},
            { "<leader>tj", desc = "Toggle Terminal 1"},
            { "<leader>tk", desc = "Toggle Terminal 2"},
            { "<leader>tl", desc = "Toggle Terminal 3"},
            { "<leader>t;", desc = "Toggle Terminal 4"},
        },
    },

    -- Tmux Navigation
    {
        "alexghergh/nvim-tmux-navigation",
        config = function ()
            dofile(plugins_path .. "nvim-tmux-navigation.lua")
        end
    },

    -- Cool Notifications
    {
         "rcarriga/nvim-notify",
        config = function ()
            dofile(plugins_path .. "nvim-notify.lua")
        end
    },

    -- Smooth Scrolling
    {"karb94/neoscroll.nvim", config = true},

    -- Help remember keymaps
    {
        "folke/which-key.nvim",
        config = function ()
            dofile(plugins_path .. "which-key.lua")
        end,
    },

    -- Improved highlighting for searching
    {
        "kevinhwang91/nvim-hlslens",
        config = function ()
            dofile(plugins_path .. "nvim-hlslens.lua")
        end,
        keys = {
            {"/"},
            {"*"},
        }
    },

    -- Various small changes
    {
        "echasnovski/mini.nvim",
        config = function ()
            dofile(plugins_path .. "mini.lua")
        end
    },

    -- Auto Pairs
    {
        "windwp/nvim-autopairs",
        config = true,
        dependencies = {
            "kevinhwang91/promise-async"
        }
    },

    -- Surround plugin
    {"kylechui/nvim-surround", config = true},

    -- AI Plugins
    {
        "jackMort/ChatGPT.nvim",
        config = function()
            dofile(plugins_path .. "chatgpt.lua")
        end,

        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        },

        keys = {
            { "<leader>ch", desc = "ChatGPT" },
        },
    }
}, {
        git = {
            -- Avoid partial clones so I have git history even offline
            filter = false,
        }
})

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts)
