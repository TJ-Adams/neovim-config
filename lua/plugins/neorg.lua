local function get_current_year()
    return os.date "%Y"
end

local function get_current_week()
    local days_in_week = 7

    local current_year = get_current_year()
    local first_day_of_year = os.time({ year = tostring(current_year), month = 1, day = 1 })
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
vim.keymap.set("n", "<leader>njt", "<cmd>Neorg journal today<cr>")

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.norg",
    callback = function()
        -- Keybinds for the journal module
        vim.keymap.set("n", "<leader>njc", "<cmd>Neorg journal custom<cr>")
        vim.keymap.set("n", "<leader>njf", "<cmd>Neorg journal tomorrow<cr>")
        vim.keymap.set("n", "<leader>njy", "<cmd>Neorg journal yesterday<cr>")
        vim.keymap.set("n", "<leader>njL", "<cmd>edit journal/life.norg<cr>")
        -- vim.keymap.set("n", "<leader>njY", "<cmd>edit journal/2024/year.norg<cr>")
        vim.keymap.set("n", "<leader>njY", function()
            vim.api.nvim_command("edit " .. "journal/" .. get_current_year() .. "/year.norg")
        end)
        -- vim.keymap.set("n", "<leader>njw", "<cmd>edit journal/2024/week.norg<cr>")
        vim.keymap.set("n", "<leader>njw", function()
            vim.api.nvim_command(
                "edit " .. "journal/" .. get_current_year() .. "/weeks/" .. "w" .. get_current_week() .. ".norg"
            )
        end)
        -- vim.keymap.set("n", "<leader>njm", "<cmd>edit journal/2024/month.norg<cr>")
        vim.keymap.set("n", "<leader>njm", function()
            vim.api.nvim_command(
                "edit " .. "journal/" .. get_current_year() .. "/months/" .. "m" .. get_current_month() .. ".norg"
            )
        end)
        -- vim.keymap.set("n", "<leader>njq", "<cmd>edit journal/2024/quarter.norg<cr>")
        vim.keymap.set("n", "<leader>njq", function()
            vim.api.nvim_command(
                "edit " .. "journal/" .. get_current_year() .. "/quarters/" .. "q" .. get_current_quarter() .. ".norg"
            )
        end)

        -- Keybinds for the calendar module
        vim.keymap.set(
            "n",
            "<leader>nc",
            '<cmd>:lua require"neorg".modules.get_module("core.ui.calendar").select_date({})<cr>'
        )

        -- Keybinds for Tasks
        vim.keymap.set("n", "<leader>tc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)")
        vim.keymap.set("n", "<leader>td", "<Plug>(neorg.qol.todo-items.todo.task-done)")
        vim.keymap.set("n", "<leader>th", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)")
        vim.keymap.set("n", "<leader>tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)")
        vim.keymap.set("n", "<leader>tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)")

    end,
})

return {
    "nvim-neorg/neorg",
    opts = {
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.keybinds"] = {},
            ["core.journal"] = {},
        },
    },
}
