local status_ok, pairs = pcall(require, "nvim-autopairs")
if not status_ok then
    return
end

pairs.setup()
