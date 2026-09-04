local M = {}

-- Path of `file` relative to nvim's cwd. Both sides are resolved first: a
-- buffer opened by absolute path, or a cwd that is a symlinked project dir
-- while the file came in already resolved (or the other way around), would
-- otherwise leave the "relative" path absolute.
function M.relative(file)
    if file == nil or file == "" then
        return file
    end
    file = vim.fn.resolve(vim.fn.fnamemodify(file, ":p"))
    local cwd = vim.fn.resolve(vim.fn.getcwd())
    if file:sub(1, #cwd + 1) == cwd .. "/" then
        return file:sub(#cwd + 2)
    end
    return vim.fn.fnamemodify(file, ":.") -- fall back to Vim's relativizer
end

return M
