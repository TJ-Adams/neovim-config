-- Disable conceal on .json files
vim.opt.conceallevel = 0

-- `:sort` moves lines but leaves their commas behind, which breaks the JSON.
-- `:SortJson` takes the same range, bang and flags and keeps the commas right;
-- with no range it sorts the whole file. See core/json_sort.lua.
vim.api.nvim_buf_create_user_command(0, "SortJson", function(cmd)
    require("core.json_sort").sort(cmd.line1, cmd.line2, cmd.bang, cmd.args)
end, { range = "%", bang = true, nargs = "*", desc = "Sort lines, fixing JSON commas" })
