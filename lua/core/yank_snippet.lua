-- Yank a range of lines as a fenced markdown code block, ready to paste into
-- an AI chat or a review comment.
--
-- The first line *inside* the fence is a comment naming the file and the line
-- range. Keeping it inside means it can never get separated from the code it
-- labels when the block is quoted and re-quoted, and because it uses the
-- buffer's own comment syntax the snippet stays valid if it's pasted straight
-- back into a file:
--
--     ```lua
--     -- lua/core/keymaps.lua:72-74
--
--     keymap("n", "<leader>ya", ...)
--     ```

local path = require "core.path"

local M = {}

-- `text` wrapped in the buffer's comment syntax. `commentstring` is a template
-- like "-- %s" or "/*%s*/"; we rebuild it with our own spacing so both shapes
-- come out evenly padded. Filetypes that set no commentstring get "#", by far
-- the most common marker among them.
local function commented(text)
    local left, right = tostring(vim.bo.commentstring):match "^(.-)%%s(.-)$"
    left = left and vim.trim(left) or ""
    right = right and vim.trim(right) or ""
    if left == "" then
        left = "#"
    end
    return left .. " " .. text .. (right ~= "" and " " .. right or "")
end

-- A fence long enough to survive the content: markdown needs the opening run
-- of backticks to be longer than any run inside the block, which matters when
-- yanking from markdown files that contain code blocks of their own.
local function fence_for(lines)
    local longest = 0
    for _, line in ipairs(lines) do
        for run in line:gmatch "`+" do
            longest = math.max(longest, #run)
        end
    end
    return string.rep("`", math.max(3, longest + 1))
end

-- Honor an explicit register prefix (`"ay<motion>`), but default to the
-- system clipboard rather than the unnamed register -- these snippets are
-- almost always headed out of nvim entirely.
local function target_register()
    local reg = vim.v.register
    if reg == "" or reg == '"' then
        return "+"
    end
    return reg
end

-- Yank buffer lines `first`..`last` (1-indexed, inclusive) as a code block.
function M.yank(first, last)
    if first > last then
        first, last = last, first
    end

    local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    if #lines == 0 then
        return
    end

    local name = vim.api.nvim_buf_get_name(0)
    local location = name ~= "" and path.relative(name) or "[No Name]"
    location = location .. ":" .. first .. (last > first and "-" .. last or "")

    local fence = fence_for(lines)
    -- Blank line after the header: it's data *about* the snippet, so it reads
    -- better set apart from the code rather than as its first line.
    local block = { fence .. vim.bo.filetype, commented(location), "" }
    vim.list_extend(block, lines)
    block[#block + 1] = fence

    vim.fn.setreg(target_register(), table.concat(block, "\n") .. "\n", "l")
end

-- `operatorfunc` for the normal-mode operator. The motion's start and end land
-- in the `[` and `]` marks; we only ever read their line numbers, so even a
-- charwise motion (`<leader>ysiw`) yanks whole lines -- a snippet clipped
-- mid-line would make the line range in the header a lie.
function M.opfunc()
    M.yank(vim.api.nvim_buf_get_mark(0, "[")[1], vim.api.nvim_buf_get_mark(0, "]")[1])
end

return M
