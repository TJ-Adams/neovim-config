local status_ok, conflict = pcall(require, "git-conflict")
if not status_ok then
    return
end

conflict.setup()

local hydra_ok, hydra = pcall(require, "hydra")
if not hydra_ok then
    return
end

local hint = [[
                   | Git Conflicts Mode |

 _j_: next conflict   _o_: choose ours       _b_: choose both
 _k_: prev conflict   _t_: choose theirs     _x_: choose none   _q_: quit
]]

local conflict_hydra = hydra({
    name = "Git Conflicts",
    hint = hint,
    config = {
        hint = {
            border = "rounded",
        },
    },
    heads = {
        { "j", "<cmd>GitConflictNextConflict<cr>" },
        { "k", "<cmd>GitConflictPrevConflict<cr>" },
        { "o", "<cmd>GitConflictChooseOurs<cr>" },
        { "t", "<cmd>GitConflictChooseTheirs<cr>" },
        { "b", "<cmd>GitConflictChooseBoth<cr>" },
        { "x", "<cmd>GitConflictChooseNone<cr>" },
        { "q", nil, { exit = true } },
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "gc", function()
    conflict_hydra:activate()
end, opts)
