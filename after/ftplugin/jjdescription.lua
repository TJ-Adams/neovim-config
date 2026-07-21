-- Formatting for `jj describe` / `jj desc` buffers.
--
-- Neovim's built-in jjdescription ftplugin already sets textwidth=72, so typing
-- auto-wraps. But pasted text (or an AI-written description) arrives as one long
-- unwrapped line. `<leader>bf` re-flows the body to 72 cols while leaving things
-- that must not be touched alone:
--   * the subject (first line) is never wrapped
--   * `JJ:` comment lines (jj's instructions, may appear mid-message)
--   * trailer/tag lines: `Key: value` and `Key=value` (e.g. Signed-off-by:)
--   * fenced code blocks (``` or ~~~) are kept verbatim
--   * inline `code spans` are treated as a single unbreakable token
--   * list items keep their marker and get a hanging indent

local BODY_WIDTH = 72

-- Split text into words, but a backtick-delimited span counts as ONE token so
-- an inline `code span` (which may contain spaces) never gets wrapped apart.
local function tokenize(text)
    local tokens = {}
    local i, n = 1, #text
    while i <= n do
        local _, ws_end = text:find("^%s+", i)
        if ws_end then
            i = ws_end + 1
        end
        if i > n then
            break
        end
        local start = i
        local in_tick = false
        while i <= n do
            local c = text:sub(i, i)
            if c == "`" then
                in_tick = not in_tick
                i = i + 1
            elseif not in_tick and c:match("%s") then
                break
            else
                i = i + 1
            end
        end
        table.insert(tokens, text:sub(start, i - 1))
    end
    return tokens
end

-- Greedy word-wrap. A token longer than the width overflows on its own line
-- rather than being split (keeps URLs and code spans intact).
local function wrap_tokens(tokens, first_prefix, cont_prefix, width)
    local lines = {}
    local cur, has_word = first_prefix, false
    for _, tok in ipairs(tokens) do
        if not has_word then
            cur, has_word = cur .. tok, true
        elseif vim.fn.strdisplaywidth(cur .. " " .. tok) <= width then
            cur = cur .. " " .. tok
        else
            table.insert(lines, cur)
            cur, has_word = cont_prefix .. tok, true
        end
    end
    if has_word then
        table.insert(lines, cur)
    end
    return lines
end

-- Trailer/tag lines like `Signed-off-by: Name <e@mail>` or `Change-Id=I9f...`.
-- The key is a single token (no spaces), which is what distinguishes a trailer
-- from ordinary prose that happens to contain a colon.
local function is_trailer(line)
    return line:match("^[%w][%w._-]*:%s") ~= nil
        or line:match("^[%w][%w._-]*:$") ~= nil
        or line:match("^[%w][%w._-]*=") ~= nil
end

local function is_fence(line)
    return line:match("^%s*```") ~= nil or line:match("^%s*~~~") ~= nil
end

local function format_buffer(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local out = {}
    local para -- { text, first, cont } accumulated prose to be re-flowed

    local function flush()
        if not para then
            return
        end
        local tokens = tokenize(para.text)
        for _, l in ipairs(wrap_tokens(tokens, para.first, para.cont, BODY_WIDTH)) do
            table.insert(out, l)
        end
        para = nil
    end

    local in_code = false
    for idx, line in ipairs(lines) do
        if idx == 1 then
            -- Subject line: never touched.
            table.insert(out, line)
        elseif in_code then
            table.insert(out, line)
            if is_fence(line) then
                in_code = false
            end
        elseif is_fence(line) then
            flush()
            table.insert(out, line)
            in_code = true
        elseif line:match("^%s*$") or line:match("^JJ:") or is_trailer(line) then
            -- Blank lines, jj comments and trailers end a paragraph and pass through.
            flush()
            table.insert(out, line)
        else
            local indent, marker = line:match("^(%s*)([-*+]%s+)")
            if not marker then
                local ind, num = line:match("^(%s*)(%d+[.)]%s+)")
                if num then
                    indent, marker = ind, num
                end
            end
            if marker then
                -- List item: start a new paragraph, hanging-indented under the text.
                flush()
                local content = line:sub(#indent + #marker + 1)
                local hang = indent .. string.rep(" ", vim.fn.strdisplaywidth(marker))
                para = { text = content, first = indent .. marker, cont = hang }
            else
                local content = line:gsub("^%s+", "")
                if para then
                    para.text = para.text .. " " .. content
                else
                    local ws = line:match("^(%s*)")
                    para = { text = content, first = ws, cont = ws }
                end
            end
        end
    end
    flush()

    -- Only rewrite the buffer when something actually changed, so a no-op format
    -- doesn't dirty the buffer or add an undo step.
    if not vim.deep_equal(lines, out) then
        local view = vim.fn.winsaveview()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out)
        vim.fn.winrestview(view)
    end
end

vim.keymap.set("n", "<leader>bf", function()
    format_buffer(0)
end, { buffer = true, desc = "Format Buffer (jj description)", silent = true })
