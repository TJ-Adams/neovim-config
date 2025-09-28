vim.lsp.config("clangd", {
    root_markers = { ".clang-format", "compile_commands.json" },
})
vim.lsp.enable("clangd")

-- NOTE: Some compile_commands.json will have gcc specific arguments
-- that are unknown to clangd. For example -fno-diagnostics-show-caret
-- is unknown to clangd. This will report the error in every file which
-- can be annoying. In that case you can add a .clangd file to the root
-- of your project with the following contents to ignore those.
-- CompileFlags:
--   Add: -Wno-unknown-warning-option
--   Remove: [-m*, -f*]
