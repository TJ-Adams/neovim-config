return {
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
}
