-- Append-yank: `Y` yanks the way `y` does, but *adds* to the clipboard instead
-- of replacing it, so a snippet can be gathered from several places in a file
-- (or several files) before pasting it somewhere else.
--
-- The join follows the shape of what's being yanked, because that's what the
-- pieces are: words collected with `Yiw Yiw` are parts of one line and get a
-- space between them, while lines collected with `YY YY` are separate lines and
-- get a newline. A single linewise piece makes the whole register linewise --
-- once one of the pieces is a whole line, the result can't sensibly paste as
-- part of an existing line.

local M = {}

-- Honor an explicit register prefix (`"aY<motion>`), but default to the system
-- clipboard. With 'clipboard' set to "unnamedplus" v:register is already "+"
-- for an unprefixed yank; the check keeps the default right if that setting
-- ever changes.
local function target_register()
    local reg = vim.v.register
    if reg == "" or reg == '"' then
        return "+"
    end
    return reg
end

local function is_linewise(regtype)
    return regtype:sub(1, 1) == "V"
end

-- Append `lines` to the target register. `linewise` says whether the yanked
-- text is a set of whole lines; charwise pieces are joined with a space.
function M.append(lines, linewise)
    if #lines == 0 then
        return
    end

    local reg = target_register()
    local existing = vim.fn.getreg(reg)

    -- Nothing to append to: this is just a yank.
    if existing == "" then
        vim.fn.setreg(reg, lines, linewise and "l" or "c")
        return
    end

    if linewise or is_linewise(vim.fn.getregtype(reg)) then
        local existing_lines = vim.split(existing, "\n")
        -- A linewise register's text ends in a newline, so splitting it leaves
        -- an empty last element. Dropping it keeps repeated appends from
        -- growing a blank line between every piece.
        if existing_lines[#existing_lines] == "" then
            table.remove(existing_lines)
        end
        vim.list_extend(existing_lines, lines)
        vim.fn.setreg(reg, existing_lines, "l")
        return
    end

    local text = table.concat(lines, "\n")
    -- Don't double up on whitespace that's already there -- `Yiw` on a word
    -- followed by `Yaw` on the next one shouldn't produce two spaces.
    local sep = (existing:match "%s$" or text:match "^%s") and "" or " "
    vim.fn.setreg(reg, existing .. sep .. text, "c")
end

-- `operatorfunc` for the normal-mode operator. `motion` is "line", "char" or
-- "block"; the motion's ends are in the `[` and `]` marks, inclusive.
function M.opfunc(motion)
    local regtype = ({ line = "V", block = "\22" })[motion] or "v"
    local region = vim.fn.getregion(vim.fn.getpos "'[", vim.fn.getpos "']", { type = regtype })
    M.append(region, motion ~= "char")
end

-- The visual-mode entry point. Called from visual mode, so the selection's ends
-- are read from `v` and `.`: `'<` and `'>` are only updated on leaving visual
-- mode and would still describe the *previous* selection.
function M.visual()
    local mode = vim.fn.mode()
    local region = vim.fn.getregion(vim.fn.getpos "v", vim.fn.getpos ".", { type = mode })
    M.append(region, mode ~= "v")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

return M
