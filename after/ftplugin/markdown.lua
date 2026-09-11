vim.opt.conceallevel = 0

-- Plain mdformat is strict CommonMark, which has no tables, so it rewraps them
-- as paragraphs. Install it with the GFM plugin:
--   uv tool install mdformat --with mdformat-gfm
-- `--number` keeps consecutive 1. 2. 3. numbering; without it mdformat
-- collapses every ordered-list item to `1.`.
local mdformat = { "mdformat", "--number", "--wrap", "100", "-" }

-- Neovim shifts the cursor for edits made *around* it, but a line the cursor
-- sits on gets replaced wholesale, so a rewrapped paragraph would strand it at
-- the truncated line end. Rewrapping only redistributes whitespace, so find the
-- cursor's word again by counting the non-blank characters ahead of it.
local function follow_cursor(lines, row, col, hunk, formatted)
    local start_a, count_a, start_b, count_b = unpack(hunk)
    local a = table.concat(vim.list_slice(lines, start_a, start_a + count_a - 1), "\n")
    local b = table.concat(vim.list_slice(formatted, start_b, start_b + count_b - 1), "\n")

    -- How far into the hunk the cursor sits, in non-blank characters.
    local offset = col
    for i = start_a, row - 1 do
        offset = offset + #lines[i] + 1
    end
    local _, wanted = a:sub(1, offset):gsub("%S", "")

    -- Walk the reflowed text to the character that many non-blanks in.
    local target, seen = #b, 0
    for i = 1, #b do
        if b:sub(i, i):match("%S") then
            if seen == wanted then
                target = i - 1
                break
            end
            seen = seen + 1
        end
    end

    local line = start_b
    for i = start_b, start_b + count_b - 1 do
        if target <= #formatted[i] then
            break
        end
        target = target - (#formatted[i] + 1)
        line = line + 1
    end
    return math.max(line, 1), math.max(target, 0)
end

-- Pipe the buffer through mdformat and patch back only the lines that actually
-- changed. Replacing the whole buffer (`%!mdformat`) would drop the cursor on
-- line 1 and clobber marks/extmarks/folds; a diff keeps everything anchored to
-- the text it was attached to.
local function format_buffer()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local before = table.concat(lines, "\n") .. "\n"

    -- `vim.system` throws (rather than returning a code) when mdformat isn't on $PATH.
    local ok, result = pcall(function()
        return vim.system(mdformat, { stdin = before, text = true }):wait()
    end)
    if not ok or result.code ~= 0 then
        local err = vim.trim(ok and result.stderr or tostring(result))
        vim.notify(err ~= "" and err or "mdformat failed", vim.log.levels.ERROR)
        return
    end

    local after = result.stdout
    if after == before then
        return
    end

    local formatted = vim.split(after, "\n")
    if formatted[#formatted] == "" then
        table.remove(formatted)
    end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local cursor

    -- Apply hunks back-to-front so earlier indices stay valid as we edit.
    local hunks = vim.diff(before, after, { result_type = "indices" })
    for i = #hunks, 1, -1 do
        local start_a, count_a, start_b, count_b = unpack(hunks[i])
        -- Anything outside a hunk keeps its position for free; only a cursor
        -- inside one has to be tracked by hand.
        if count_a > 0 and row >= start_a and row <= start_a + count_a - 1 then
            cursor = { follow_cursor(lines, row, col, hunks[i], formatted) }
        end
        -- A hunk with no `a` lines is an insertion *after* line `start_a`.
        local first = count_a == 0 and start_a or start_a - 1
        local replacement = {}
        for j = start_b, start_b + count_b - 1 do
            table.insert(replacement, formatted[j])
        end
        vim.api.nvim_buf_set_lines(buf, first, first + count_a, false, replacement)
    end

    if cursor then
        cursor[1] = math.min(cursor[1], vim.api.nvim_buf_line_count(buf))
        cursor[2] = math.min(cursor[2], #vim.fn.getline(cursor[1]))
        vim.api.nvim_win_set_cursor(0, cursor)
    end
end

vim.keymap.set(
    "n",
    "<leader>bf",
    format_buffer,
    { buffer = true, desc = "Format Buffer (mdformat)", silent = true }
)
