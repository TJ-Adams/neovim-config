local status_ok, noice = pcall(require, "noice")
if not status_ok then
    return
end

noice.setup({
    presets = {
        bottom_search = true,
        command_palette = true,
    },

    messages = {
        enabled = false,
    },

    lsp = {
        signature = {
            -- I already have a signature provider. In the
            -- future I may consolidate though
            enabled = false,
        },
    },
})
