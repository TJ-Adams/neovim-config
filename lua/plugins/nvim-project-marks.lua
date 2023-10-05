local status_ok, projectmarks = pcall(require, "projectmarks")
if not status_ok then
    return
end

projectmarks.setup({
    shadafile = ".nvim.shada",
    mappings = false,
    message = "",
})
