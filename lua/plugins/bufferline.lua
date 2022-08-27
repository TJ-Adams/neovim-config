local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

bufferline.setup(
    {
        options = {
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left"
                }
            }
        }
    }
)

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- Navigate buffers Based on how bufferline displays them
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)

-- Reorder buffers left and right
keymap("n", "<leader>bl", ":BufferLineMoveNext<CR>", opts)
keymap("n", "<leader>bh", ":BufferLineMovePrev<CR>", opts)