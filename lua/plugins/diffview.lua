-- Neovim has one set of diff highlight groups shared by both windows, so a
-- deleted character and an added character land on the same `DiffText` group --
-- gruvbox paints both bright yellow. Diffview does tell us which side of the
-- layout each window is (`ctx.symbol`), so we can point those groups at
-- side-specific colors with a window-local `winhl` and get red for what left and
-- green for what arrived. The colors themselves live in plugins/gruvbox.lua.
local function side_winhl(winid, symbol)
    -- `b` is always the new state: the right-hand buffer in a 2-way diff, and
    -- the working copy in the merge tool. Everything else is a version we're
    -- diffing against, so it gets the "removed" treatment.
    local side = symbol == "b" and "New" or "Old"

    local ours = {
        DiffAdd = "DiffviewDiff" .. side .. "Full",
        DiffChange = "DiffviewDiff" .. side .. "Line",
        DiffText = "DiffviewDiff" .. side .. "Text",
        DiffTextAdd = "DiffviewDiff" .. side .. "Only",
        DiffDelete = "DiffviewDiffFiller",
    }

    -- Keep whatever else is already in `winhl` -- diffview has set its own diff
    -- mappings by now, and dropbar keeps a long list of its own in here too.
    local merged = {}
    local current = vim.api.nvim_get_option_value("winhl", { win = winid })
    for entry in vim.gsplit(current, ",", { trimempty = true }) do
        local from = entry:match("^([^:]+):")
        if from and not ours[from] then
            merged[#merged + 1] = entry
        end
    end
    for from, to in pairs(ours) do
        merged[#merged + 1] = from .. ":" .. to
    end

    return table.concat(merged, ",")
end

return {
    "sindrets/diffview.nvim",
    lazy = false,
    keys = {
        { "<leader>gh", "<cmd>:DiffviewFileHistory % --no-merges<cr>", desc = "Diffview File History" },
    },
    opts = {
        hooks = {
            -- Fires after diffview has applied its own winopts, so this wins.
            diff_buf_win_enter = function(_, winid, ctx)
                vim.api.nvim_set_option_value("winhl", side_winhl(winid, ctx.symbol), { win = winid })
            end,
        },
    },
}
