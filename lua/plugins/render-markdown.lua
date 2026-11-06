-- Render markdown in place (headings, lists, checkboxes, code blocks, tables).
-- Off by default; <leader>md toggles it for the current buffer only.
--
-- Styled after neorg's concealer so rendered markdown looks like a .norg file:
-- the same icons, and neorg's own `@neorg.*` highlight groups rather than
-- copies of their colors, so anything that recolors neorg recolors this too.

-- `@neorg.<prefix>.<level>.<suffix>` for heading/quote levels 1-6.
local function levels(prefix, suffix)
    local groups = {}
    for level = 1, 6 do
        groups[level] = ("@neorg.%s.%d.%s"):format(prefix, level, suffix)
    end
    return groups
end

-- A neorg todo is `( )` with the state glyph inside the parens; render
-- markdown's `[ ]` the same way, colored like the matching neorg state.
local function todo(glyph, state)
    return { icon = "(" .. glyph .. ")", highlight = "@neorg.todo_items." .. state }
end

local function custom_todo(raw, glyph, state)
    local t = todo(glyph, state)
    return { raw = raw, rendered = t.icon, highlight = t.highlight }
end

return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
        -- Defines the `@neorg.*` groups used below.
        "nvim-neorg/neorg",
    },
    ft = { "markdown" },
    keys = {
        {
            "<leader>md",
            function()
                require("render-markdown").buf_toggle()
            end,
            ft = "markdown",
            desc = "Toggle Markdown Render",
        },
    },
    opts = {
        -- Every buffer starts unrendered; buf_toggle flips just the current one.
        enabled = false,

        -- The plugin re-checks the mode after a debounce, by which time a
        -- <C-h> into a terminal split has put us in terminal-normal mode
        -- ("nt"). Without it here, the markdown window un-renders while
        -- the cursor sits in the terminal.
        render_modes = { "n", "c", "t", "nt" },

        heading = {
            -- `overlay` left-pads the icon over the `#`s, so deeper headings
            -- step right one column per level, just like neorg's `*`s.
            icons = { "◉ ", "◎ ", "○ ", "✺ ", "▶ ", "⤷ " },
            sign = false,
            foregrounds = levels("headings", "prefix"),
            -- Neorg has no heading band, only colored titles. The "background"
            -- is painted across the heading line, so giving it the fg-only
            -- title group colors the text and leaves the background alone.
            backgrounds = levels("headings", "title"),
        },

        bullet = {
            icons = { "•" },
            highlight = function(ctx)
                local ordered = ctx.value:match("%d")
                return ordered and "@neorg.lists.ordered.prefix" or "@neorg.lists.unordered.prefix"
            end,
        },

        checkbox = {
            -- Neorg keeps the list bullet in front of a todo: `• (x) task`.
            bullet = true,
            unchecked = todo(" ", "undone"),
            checked = todo("󰄬", "done"),
            -- Neorg's other todo states, written with the same characters as
            -- in a .norg file (`- [!] task` is an urgent task).
            custom = {
                todo = custom_todo("[-]", "󰥔", "pending"),
                urgent = custom_todo("[!]", "⚠", "urgent"),
                on_hold = custom_todo("[=]", "\u{F04C}", "on_hold"),
                cancelled = custom_todo("[_]", "\u{F1F8}", "cancelled"),
                uncertain = custom_todo("[?]", "\u{F420}", "uncertain"),
                recurring = custom_todo("[+]", "↺", "recurring"),
            },
        },

        quote = {
            icon = "│",
            highlight = levels("quotes", "prefix"),
        },

        dash = {
            highlight = "@neorg.delimiters.horizontal_line",
        },

        code = {
            -- Neorg shades only the code lines themselves, with its own
            -- dimmed-Normal background, and leaves the `@code`/`@end` lines as
            -- plain text: no border, no language label, fences left visible.
            sign = false,
            style = "normal",
            border = "none",
            conceal_delimiters = false,
            highlight = "@neorg.tags.ranged_verbatim.code_block",
        },
    },
}
