local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
    return
end

neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.keybinds"] = {},
        ["core.integrations.telescope"] = {},
        ["core.journal"] = {},
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function get_current_year()
    return os.date "%Y"
end

local function get_current_week()
    local days_in_week = 7

    local current_year = get_current_year()
    local first_day_of_year = os.time({ year = current_year, month = 1, day = 1 })
    local days_missing_week1 = os.date("%w", first_day_of_year)
    local year_progress_in_days = os.date "%j" + days_missing_week1

    return math.ceil(year_progress_in_days / days_in_week)
end

local function get_current_month()
    return os.date "%m"
end

local function get_current_quarter()
    local months_in_quarter = 3

    local month = get_current_month()
    local current_quarter = math.ceil(month / months_in_quarter)
    return string.format("%02d", current_quarter)
end

-- Global Neorg Journal Keymap
keymap("n", "<leader>njt", "<cmd>Neorg journal today<cr>", opts)

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.norg",
    callback = function()
        -- Keybinds for the journal module
        keymap("n", "<leader>njc", "<cmd>Neorg journal custom<cr>")
        keymap("n", "<leader>njf", "<cmd>Neorg journal tomorrow<cr>")
        keymap("n", "<leader>njy", "<cmd>Neorg journal yesterday<cr>")
        keymap("n", "<leader>njL", "<cmd>edit journal/life.norg<cr>")
        -- keymap("n", "<leader>njY", "<cmd>edit journal/2024/year.norg<cr>")
        keymap("n", "<leader>njY", function()
            vim.api.nvim_command("edit " .. "journal/" .. get_current_year() .. "/year.norg")
        end)
        -- keymap("n", "<leader>njw", "<cmd>edit journal/2024/week.norg<cr>")
        keymap("n", "<leader>njw", function()
            vim.api.nvim_command(
                "edit " .. "journal/" .. get_current_year() .. "/weeks/" .. "w" .. get_current_week() .. ".norg"
            )
        end)
        -- keymap("n", "<leader>njm", "<cmd>edit journal/2024/month.norg<cr>")
        keymap("n", "<leader>njm", function()
            vim.api.nvim_command(
                "edit " .. "journal/" .. get_current_year() .. "/months/" .. "m" .. get_current_month() .. ".norg"
            )
        end)
        -- keymap("n", "<leader>njq", "<cmd>edit journal/2024/quarter.norg<cr>")
        keymap("n", "<leader>njq", function()
            vim.api.nvim_command(
                "edit " .. "journal/" .. get_current_year() .. "/quarters/" .. "q" .. get_current_quarter() .. ".norg"
            )
        end)

        -- Keybinds for the calendar module
        keymap("n", "<leader>nc", '<cmd>:lua require"neorg".modules.get_module("core.ui.calendar").select_date({})<cr>')

        -- Keybinds for Tasks
        keymap("n", "<leader>tc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)")
        keymap("n", "<leader>td", "<Plug>(neorg.qol.todo-items.todo.task-done)")
        keymap("n", "<leader>th", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)")
        keymap("n", "<leader>tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)")
        keymap("n", "<leader>tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)")

        -- Misc
        keymap("n", "<leader>fni", "<cmd>Telescope neorg insert_link<cr>", opts)
        keymap("n", "<leader>fnh", "<cmd>Telescope neorg search_headings<cr>", opts)
    end,
})

-- Which Key Registration
local wk_status, wk = pcall(require, "which-key")
if not wk_status then
    return
end

wk.add({
    { "<leader>t", group = "Tasks or Terminal" },
})
