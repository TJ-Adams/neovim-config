local status_ok
local pairs
local cursorword

status_ok, pairs = pcall(require, "mini.pairs")
if not status_ok then
    return
end

status_ok, cursorword = pcall(require, "mini.cursorword")
if not status_ok then
        return
end

pairs.setup()
cursorword.setup()
