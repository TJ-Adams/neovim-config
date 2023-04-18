local status_ok, chatgpt = pcall(require, "chatgpt")
if not status_ok then
    return
end

chatgpt.setup( {
    popup_input = {
        submit = "<C-s>",
    }
})

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<leader>ch", "<cmd>ChatGPT<cr>", opts)
