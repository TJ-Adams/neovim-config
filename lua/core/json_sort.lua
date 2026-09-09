-- Sort JSON lines without breaking the commas.
--
-- `:sort` is a pure line sort: it moves the lines and leaves their punctuation
-- where it was, so sorting an object's body strands a comma on the new last
-- item and leaves the one that moved up without one. This runs the real
-- `:sort` -- so every flag it takes still works -- with the commas stripped
-- first and put back afterwards.
--
-- Stripping *before* the sort rather than fixing up after is what makes
-- `:sort u` work: `"a": 1,` and `"a": 1` aren't the same line, so the dedupe
-- would otherwise keep both.

local M = {}

-- Lines that are purely structural, and so aren't items to be sorted. Trimming
-- them off the ends of the range is what lets `ggVG` (or no range at all) sort
-- a whole file. Only a *bare* bracket qualifies: a nested object opens with
-- `"key": {`, which must not be trimmed away to sort its contents by accident.
local OPENERS = { ["{"] = true, ["["] = true }
local CLOSERS = { ["}"] = true, ["]"] = true, ["},"] = true, ["],"] = true }

-- Lines carrying no item: blanks, and comments for the JSONC dialects that
-- allow them. They're skipped when deciding which line ends the range.
local function is_filler(line)
    local text = vim.trim(line)
    return text == "" or text:sub(1, 2) == "//"
end

-- Whether `line` opens and closes every bracket it contains, ignoring those
-- inside strings. A line that doesn't is part of a multi-line value, which no
-- line-based sort can reorder without shredding it.
local function self_contained(line)
    local depth = 0
    local in_string, escaped = false, false

    for i = 1, #line do
        local c = line:sub(i, i)
        if in_string then
            if escaped then
                escaped = false
            elseif c == "\\" then
                escaped = true
            elseif c == '"' then
                in_string = false
            end
        elseif c == '"' then
            in_string = true
        elseif c == "/" and line:sub(i + 1, i + 1) == "/" then
            break -- a JSONC comment; brackets past here aren't structure
        elseif c == "{" or c == "[" then
            depth = depth + 1
        elseif c == "}" or c == "]" then
            depth = depth - 1
            if depth < 0 then
                return false
            end
        end
    end

    return depth == 0 and not in_string
end

-- Whether the item ending the sorted range needs a trailing comma, i.e.
-- whether anything follows it in the enclosing object or array.
local function followed_by_item(last)
    for lnum = last + 1, vim.fn.line "$" do
        local line = vim.fn.getline(lnum)
        if not is_filler(line) then
            local first_char = vim.trim(line):sub(1, 1)
            return first_char ~= "}" and first_char ~= "]"
        end
    end
    return false -- nothing left in the buffer at all
end

-- Sort buffer lines `first`..`last`, passing `bang` and `args` to `:sort`.
function M.sort(first, last, bang, args)
    if OPENERS[vim.trim(vim.fn.getline(first))] then
        first = first + 1
    end
    if CLOSERS[vim.trim(vim.fn.getline(last))] then
        last = last - 1
    end
    if first > last then
        vim.notify("SortJson: nothing to sort", vim.log.levels.WARN)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    for i, line in ipairs(lines) do
        if not is_filler(line) and not self_contained(line) then
            vim.notify(
                ("SortJson: line %d is part of a multi-line value; sorting it would break the JSON"):format(
                    first + i - 1
                ),
                vim.log.levels.ERROR
            )
            return
        end
    end

    local view = vim.fn.winsaveview()

    for i, line in ipairs(lines) do
        lines[i] = line:gsub(",%s*$", "")
    end
    vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)

    -- The strip, the sort and the re-add are one edit as far as `u` is
    -- concerned. `undojoin` errors if the previous change was itself an undo,
    -- which only costs us the joining.
    pcall(vim.cmd, "undojoin")
    local before = vim.fn.line "$"
    vim.cmd(("silent %d,%dsort%s %s"):format(first, last, bang and "!" or "", args or ""))
    -- `:sort u` drops duplicates, so the range can come back shorter.
    last = last - (before - vim.fn.line "$")

    lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)

    -- The item that ends the range is the last one that isn't a blank or a
    -- comment; `:sort` will have pushed any of those to the top, but not
    -- necessarily all of them.
    local final = nil
    for i = #lines, 1, -1 do
        if not is_filler(lines[i]) then
            final = i
            break
        end
    end

    if final then
        local trailing = followed_by_item(last)
        for i, line in ipairs(lines) do
            if not is_filler(line) and (i ~= final or trailing) then
                lines[i] = line .. ","
            end
        end
    end

    pcall(vim.cmd, "undojoin")
    vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)

    vim.fn.winrestview(view)
end

return M
