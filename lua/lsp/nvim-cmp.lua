local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
    return
end

local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
    return
end

local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup(
    {
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = {
            ["<C-k>"] = cmp.mapping.select_prev_item(),
            ["<C-j>"] = cmp.mapping.select_next_item(),
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), {"i", "c"}),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), {"i", "c"}),
            ["<C-e>"] = cmp.mapping {
                i = cmp.mapping.abort(),
                c = cmp.mapping.close()
            },
            -- Accept currently selected item. If none selected, `select` first item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm {select = true},
            ["<Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expandable() then
                        luasnip.expand()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif check_backspace() then
                        fallback()
                    else
                        fallback()
                    end
                end,
                {
                    "i",
                    "s"
                }
            ),
            ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end,
                {
                    "i",
                    "s"
                }
            )
        },
        sources = cmp.config.sources(
            {
                {name = "nvim_lsp"},
                {name = "luasnip"},
                {name = "buffer"},
                {name = "neorg"}
            }
        )
    }
)
