local animate_ok
local animate

animate_ok, animate = pcall(require, "mini.animate")
if not animate_ok then
        return
end

animate.setup( {
    -- Disable cursor animations because it slows down
    -- lightspeed.
    cursor = {
        enable = false,
    },
})
