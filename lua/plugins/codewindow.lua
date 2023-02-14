local status_ok, codewindow = pcall(require, "codewindow")
if not status_ok then
    return
end

codewindow.setup(
    {
        minimap_width = 10
    }
)

codewindow.apply_default_keybinds()