local status_ok, notify = pcall(require, "nvim-notify")
if not status_ok then
    return
end

vim.notify = require("notify")
