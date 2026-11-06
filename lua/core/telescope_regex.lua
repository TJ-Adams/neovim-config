-- Regex terms in telescope's fuzzy pickers.
--
-- `<leader>fg` greps with ripgrep, so `\bsg.h` finds `sg.h` but not `msg.h`.
-- The fuzzy pickers (`<leader>ff`, `<leader>fb`, refine, ...) only speak fzf's
-- syntax. This wraps the fzf sorters so a prompt can mix the two: every
-- space-separated term that looks like a regex becomes a filter, and the rest
-- is fuzzy-matched and ranked by fzf as before.
--
--   \bsg.h          only entries with a word starting "sg" + any char + "h"
--   \btest\b lua    a whole-word "test", fuzzy "lua" for the ranking
--   !\bspec\b       drop entries containing the word "spec"
--
-- A term counts as a regex when it has a backslash or one of `[](){}*+?`, or
-- a `|` inside it. A lone `.` doesn't count, so `init.lua` stays a fuzzy
-- term: fuzzy matching already lets anything sit between the letters, and
-- file names are full of dots. Inside a regex term `.` is the usual wildcard.
-- A term that isn't a valid regex yet (half typed, like `\` or `(foo`) is
-- ignored until it is.
--
-- The syntax is the ripgrep/PCRE one (`\b \B \d \w \s`, classes, groups,
-- `(?:...)`, `{n,m}`, lazy `*?`), translated to a Vim regex. Case follows
-- smart case, like the fzf terms: all lowercase means ignore case.
local M = {}

local class_escapes = { d = "0-9", w = "0-9A-Za-z_", s = " \t" }

-- Translate a PCRE-style pattern into a very magic (`\v`) Vim pattern, or nil
-- if it can't be translated (unterminated class, trailing backslash).
local function translate(pat)
    local out, i, n = {}, 1, #pat
    local function emit(s)
        out[#out + 1] = s
    end
    while i <= n do
        local c = pat:sub(i, i)
        if c == "\\" then
            local e = pat:sub(i + 1, i + 1)
            if e == "" then
                return nil
            elseif e == "b" then
                emit "%(<|>)"
            elseif e == "B" then
                emit "%(<|>)@!"
            elseif e:match "[dDwWsSnt]" then
                emit("\\" .. e)
            elseif e:match "%w" then
                emit(e) -- unknown letter escape: take the letter literally
            else
                emit("\\" .. e) -- escaped punctuation is literal
            end
            i = i + 2
        elseif c == "[" then
            local j, body = i + 1, {}
            if pat:sub(j, j) == "^" then
                body[#body + 1] = "^"
                j = j + 1
            end
            if pat:sub(j, j) == "]" then
                body[#body + 1] = "\\]"
                j = j + 1
            end
            while j <= n and pat:sub(j, j) ~= "]" do
                local d = pat:sub(j, j)
                if d == "\\" then
                    local e = pat:sub(j + 1, j + 1)
                    body[#body + 1] = class_escapes[e] or ("\\" .. e)
                    j = j + 2
                else
                    body[#body + 1] = d
                    j = j + 1
                end
            end
            if j > n then
                return nil
            end
            emit("[" .. table.concat(body) .. "]")
            i = j + 1
        elseif c == "(" then
            if pat:sub(i + 1, i + 2) == "?:" then
                emit "%("
                i = i + 3
            else
                emit "("
                i = i + 1
            end
        elseif c == "*" or c == "+" or c == "?" then
            if pat:sub(i + 1, i + 1) == "?" then
                emit(({ ["*"] = "{-}", ["+"] = "{-1,}", ["?"] = "{-0,1}" })[c])
                i = i + 2
            else
                emit(c)
                i = i + 1
            end
        elseif c == "{" then
            local q = pat:match("^{%d*,?%d*}", i)
            if q and q ~= "{}" and q ~= "{,}" then
                local lazy = pat:sub(i + #q, i + #q) == "?"
                emit(lazy and ("{-" .. q:sub(2)) or q)
                i = i + #q + (lazy and 1 or 0)
            else
                emit "\\{"
                i = i + 1
            end
        elseif c:match "[<>=@%%~&}]" then
            emit("\\" .. c) -- special in very magic, literal in PCRE
            i = i + 1
        else
            emit(c) -- letters, digits, . ^ $ | ) and other punctuation
            i = i + 1
        end
    end
    return table.concat(out)
end

local function is_regex(term)
    return term:find "[\\%[%]%(%)%{%}%*%+%?]" ~= nil or (#term > 1 and term:find("|", 1, true) ~= nil)
end

-- Compile a regex term, or nil if it isn't valid (yet).
local function compile(term)
    local vim_pat = translate(term)
    if not vim_pat then
        return nil
    end
    -- Smart case: an uppercase letter that isn't part of an escape (\W, \B, ...)
    local case = term:gsub("\\.", ""):find "%u" and "\\C" or "\\c"
    local ok, re = pcall(vim.regex, "\\v" .. case .. vim_pat)
    return ok and re or nil
end

-- Split a prompt into regex filters and the fuzzy remainder.
-- Terms are separated by unescaped whitespace (fzf's `\ ` stays in a term).
local function parse(prompt)
    local regexes, fuzzy, has_regex = {}, {}, false
    local term_start, i = nil, 1
    local terms = {}
    while i <= #prompt + 1 do
        local c = prompt:sub(i, i)
        if c == "\\" then
            term_start = term_start or i
            i = i + 2
        elseif c == "" or c:match "%s" then
            if term_start then
                terms[#terms + 1] = prompt:sub(term_start, i - 1)
                term_start = nil
            end
            i = i + 1
        else
            term_start = term_start or i
            i = i + 1
        end
    end
    if term_start then -- a trailing `\` skips past the end above
        terms[#terms + 1] = prompt:sub(term_start)
    end
    for _, term in ipairs(terms) do
        local negate = term:sub(1, 1) == "!" and #term > 1
        local body = negate and term:sub(2) or term
        if is_regex(body) then
            has_regex = true
            local re = compile(body)
            if re then
                regexes[#regexes + 1] = { re = re, negate = negate }
            end
        else
            fuzzy[#fuzzy + 1] = term
        end
    end
    return { has_regex = has_regex, regexes = regexes, fuzzy = table.concat(fuzzy, " ") }
end

-- Byte ranges of every match of `re` in `s`, as telescope highlights.
local function match_ranges(re, s, out)
    local offset = 0
    while offset < #s do
        local from, to = re:match_str(s:sub(offset + 1))
        if not from then
            break
        end
        if to > from then
            out[#out + 1] = { start = offset + from + 1, finish = offset + to }
        end
        offset = offset + math.max(to, from + 1)
    end
end

-- Wrap a sorter factory (conf.file_sorter / conf.generic_sorter).
function M.wrap(make_sorter)
    return function(opts)
        local sorter = make_sorter(opts)
        local score, highlight, start = sorter.scoring_function, sorter.highlighter, sorter.start
        local cache = {}
        local function parsed(prompt)
            local p = cache[prompt]
            if not p then
                p = parse(prompt)
                cache[prompt] = p
            end
            return p
        end

        sorter.start = function(self, prompt)
            if start then
                start(self, prompt)
            end
            -- Telescope skips entries an earlier, shorter prompt filtered out,
            -- assuming more typing only narrows. Regexes can widen (`ab` ->
            -- `ab?`), so don't let it.
            if parsed(prompt).has_regex then
                self._discard_state.filtered = {}
            end
        end

        sorter.scoring_function = function(self, prompt, line, ...)
            local p = parsed(prompt)
            if not p.has_regex then
                return score(self, prompt, line, ...)
            end
            for _, r in ipairs(p.regexes) do
                if (r.re:match_str(line) ~= nil) == r.negate then
                    return -1
                end
            end
            if p.fuzzy == "" then
                return 1 -- regex terms only: keep the picker's own order
            end
            return score(self, p.fuzzy, line, ...)
        end

        sorter.highlighter = function(self, prompt, display)
            local p = parsed(prompt)
            if not p.has_regex then
                return highlight(self, prompt, display)
            end
            local hls = p.fuzzy ~= "" and highlight(self, p.fuzzy, display) or {}
            for _, r in ipairs(p.regexes) do
                if not r.negate then
                    match_ranges(r.re, display, hls)
                end
            end
            return hls
        end

        return sorter
    end
end

-- Wrap telescope's file and generic sorters. Call after the fzf extension
-- has installed its sorters.
function M.setup()
    local conf = require("telescope.config").values
    conf.file_sorter = M.wrap(conf.file_sorter)
    conf.generic_sorter = M.wrap(conf.generic_sorter)
end

M._translate, M._parse = translate, parse -- for testing

return M
