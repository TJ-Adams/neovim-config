local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP =
        fn.system(
        {
            "git",
            "clone",
            "https://github.com/wbthomason/packer.nvim",
            install_path
        }
    )
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd(
    [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]]
)

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Install Plugins
return packer.startup(
    function(use)
        -- Common Plugin Dependencies
        use "nvim-lua/plenary.nvim"
        use "kyazdani42/nvim-web-devicons"
        use "kevinhwang91/promise-async"

        -- Plugin Manager
        use "wbthomason/packer.nvim"

        -- Telescope (Fuzzy Finding)
        use "nvim-telescope/telescope.nvim"

        -- Telescope Extensions
        use "https://github.com/nvim-telescope/telescope-project.nvim"
        use {
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
        }

        -- File Explorer
        use "kyazdani42/nvim-tree.lua"

        -- Git Integration
        use "lewis6991/gitsigns.nvim"
        use "tpope/vim-fugitive"

        -- Lazy Git Usage
        use "kdheepak/lazygit.nvim"

        -- Status Line
        use "nvim-lualine/lualine.nvim"

        -- Show context around code
        use "nvim-treesitter/nvim-treesitter-context"

        -- Quick Movements
        use "ggandor/lightspeed.nvim"

        -- Quick Movements
        use "kevinhwang91/nvim-ufo"

        -- LSP Plugins
        use "williamboman/mason.nvim"
        use "williamboman/mason-lspconfig.nvim"
        use "neovim/nvim-lspconfig" -- Configurations for Nvim LSP
        use "hrsh7th/nvim-cmp"
        use "L3MON4D3/LuaSnip"
        use "hrsh7th/cmp-nvim-lsp"
        use "ray-x/lsp_signature.nvim"

        -- Show definition in floating preview window
        use "rmagatti/goto-preview"

        -- Show buffers like web browser tabs
        use "akinsho/bufferline.nvim"

        -- Minimap Support, Depends on code-minimap
        use "wfxr/minimap.vim"

        -- nvim-treesitter
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

        -- Aerial for outline of file
        use "stevearc/aerial.nvim"

        -- Tmux Navigation
        use "akinsho/toggleterm.nvim"

        -- Tmux Navigation
        use "alexghergh/nvim-tmux-navigation"

        -- Colorscheme Plugins
        use "ellisonleao/gruvbox.nvim"
        use "Shatur/neovim-ayu"

        -- Cool Notifications
        use "rcarriga/nvim-notify"

        -- Smooth Scrolling
        use "karb94/neoscroll.nvim"

        -- Help remember keymaps
        use "folke/which-key.nvim"

        -- tldr searcher with telescope
        use "mrjones2014/tldr.nvim"

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if PACKER_BOOTSTRAP then
            require("packer").sync()
        end
    end
)
