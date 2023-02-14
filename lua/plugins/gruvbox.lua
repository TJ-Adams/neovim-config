
-- Change certain highlight groups to make telescope
-- look nicer

local orange = "#FF6347"
local black  = "#000000"
local grey  = "#303030"
local dark_grey  = "#202020"

vim.api.nvim_set_hl(0, "TelescopeTitle", { bg=orange })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg=black, bg=orange })
vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg=black, bg=orange })
vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg=orange })

vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg=grey })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg=grey })

vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg=dark_grey })
vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg=dark_grey })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg=dark_grey })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg=dark_grey })

