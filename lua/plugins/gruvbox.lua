return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        local orange = "#FF6347"
        local black = "#000000"
        local gruvbox_text = "#EBDBB2"
        local grey = "#303030"
        local dark_grey = "#202020"

        -- Diff palette.
        --
        -- Two families -- one for the old side, one for the new side -- blended
        -- from gruvbox red and a green nudged off gruvbox's olive so it doesn't
        -- read as yellow. Red carries far more chroma than green at the same
        -- luminance, so the red tiers sit a little darker to stop the left-hand
        -- side of a diff from shouting louder than the right.
        --
        -- Within a family the tint gets stronger as the change gets more
        -- specific, so the eye lands on the exact characters that changed:
        --   line (rest of a modified line) < full line < changed chars < chars
        --   that have no counterpart at all.
        local diff = {
            old_line = "#4C2E2A", -- untouched remainder of a modified line
            old_full = "#6A322C", -- whole line, present only on the old side
            old_text = "#8C382E", -- chars replaced by something else
            old_only = "#A23B2F", -- chars with no counterpart: pure deletions
            new_line = "#404630",
            new_full = "#495133",
            new_text = "#5A6539",
            new_only = "#65723C",
            -- Neutral tier, for diffs where nvim can't tell which buffer is older
            neutral_line = "#2E3D3E",
            neutral_text = "#3A6162",
            neutral_only = "#3E6E70",
            -- Filler lines: just enough to see the hatching, never enough to
            -- compete with real content.
            filler = "#3C3836",
        }

        local function set_highlights()
            local hl = function(group, opts)
                vim.api.nvim_set_hl(0, group, opts)
            end

            hl("TelescopeTitle", { bg = orange })
            hl("TelescopePromptTitle", { fg = black, bg = orange })
            hl("TelescopePreviewTitle", { fg = black, bg = orange })
            hl("TelescopeResultsTitle", { bg = orange })

            hl("TelescopePromptBorder", { bg = grey })
            hl("TelescopePromptNormal", { bg = grey })

            hl("TelescopePreviewBorder", { bg = dark_grey })
            hl("TelescopePreviewNormal", { bg = dark_grey })
            hl("TelescopeResultsBorder", { bg = dark_grey })
            hl("TelescopeResultsNormal", { bg = dark_grey })

            -- I think the yellow highlight is very distracting so I'm removing it
            hl("Todo", { fg = gruvbox_text, bold = true })
            hl("@text.todo", { fg = gruvbox_text, bold = true })

            -- For Gitsigns current line blame feature
            hl("GitSignsCurrentLineBlame", { link = "@Comment" })

            -- Green for folder names doesn't look good
            hl("NvimTreeFolderName", { link = "@GruvboxBlueBold" })

            -- Don't highlight markdown errors in bright red
            hl("markdownError", { link = "@GruvboxBlueBold" })

            -- Remove the strikethrough for deprecated. It can make text difficult to read.
            hl("DiagnosticDeprecated", {})

            -- Diffs ---------------------------------------------------------
            -- These are the side-agnostic defaults: plain `vimdiff`, `:diffthis`
            -- and gitsigns previews have no idea which window holds the older
            -- version, so anything ambiguous stays neutral. Diffview knows which
            -- side is which and remaps these per window (see plugins/diffview.lua).
            hl("DiffAdd", { bg = diff.new_full })
            hl("DiffDelete", { fg = diff.filler, bg = "NONE" })
            hl("DiffChange", { bg = diff.neutral_line })
            hl("DiffText", { bg = diff.neutral_text, bold = true })
            hl("DiffTextAdd", { bg = diff.neutral_only, bold = true })

            -- Per-side groups. `Old` is the left/before buffer, `New` is the
            -- right/after buffer. Mapped onto the builtin groups as:
            --   DiffAdd     -> *Full  (line exists only in this buffer)
            --   DiffChange  -> *Line  (line exists on both sides but differs)
            --   DiffText    -> *Text  (the differing chars, both sides)
            --   DiffTextAdd -> *Only  (chars with no counterpart at all)
            hl("DiffviewDiffOldFull", { bg = diff.old_full })
            hl("DiffviewDiffOldLine", { bg = diff.old_line })
            hl("DiffviewDiffOldText", { bg = diff.old_text, bold = true })
            hl("DiffviewDiffOldOnly", { bg = diff.old_only, bold = true })

            hl("DiffviewDiffNewFull", { bg = diff.new_full })
            hl("DiffviewDiffNewLine", { bg = diff.new_line })
            hl("DiffviewDiffNewText", { bg = diff.new_text, bold = true })
            hl("DiffviewDiffNewOnly", { bg = diff.new_only, bold = true })

            hl("DiffviewDiffFiller", { fg = diff.filler, bg = "NONE" })

            -- Patch syntax: `.diff`/`.patch` files, `git show` output and the
            -- diff shown under a commit message. Gruvbox rides these on
            -- DiffAdd/DiffDelete, which no longer works now that DiffDelete only
            -- paints filler lines, so give them their own colors.
            hl("diffAdded", { bg = diff.new_full })
            hl("diffRemoved", { bg = diff.old_full })

            -- Gitsigns hunk previews. Both sides live in one buffer here, so the
            -- line type tells us which family to use. The inline groups otherwise
            -- fall back to TermCursor, which is a reversed block.
            hl("GitSignsAddPreview", { bg = diff.new_full })
            hl("GitSignsDeletePreview", { bg = diff.old_full })
            hl("GitSignsAddInline", { bg = diff.new_only, bold = true })
            hl("GitSignsDeleteInline", { bg = diff.old_only, bold = true })
            hl("GitSignsChangeInline", { bg = diff.new_text, bold = true })

            -- Diffview's file panel. Gruvbox links the modified status to green,
            -- which makes modified files read as additions at a glance. The
            -- rename/copy/typechange statuses have no link at all and fall
            -- through to a background band.
            hl("DiffviewStatusModified", { link = "GruvboxYellowBold" })
            hl("DiffviewStatusRenamed", { link = "GruvboxYellowBold" })
            hl("DiffviewStatusCopied", { link = "GruvboxYellowBold" })
            hl("DiffviewStatusTypeChanged", { link = "GruvboxYellowBold" })
            hl("DiffviewStatusUnmerged", { link = "GruvboxOrangeBold" })
            hl("DiffviewStatusAdded", { link = "GruvboxGreenBold" })
            hl("DiffviewStatusUntracked", { link = "GruvboxGreenBold" })
            hl("DiffviewStatusDeleted", { link = "GruvboxRedBold" })
            hl("DiffviewFilePanelConflicts", { link = "GruvboxOrangeBold" })
        end

        -- Re-apply on every colorscheme load, otherwise a `:colorscheme gruvbox`
        -- (or any plugin that reloads it) silently drops all of the above.
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "gruvbox",
            group = vim.api.nvim_create_augroup("GruvboxOverrides", { clear = true }),
            callback = set_highlights,
        })

        vim.cmd [[colorscheme gruvbox]]
    end,
}
