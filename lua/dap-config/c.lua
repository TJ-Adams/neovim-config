local status_ok, dap = pcall(require, "dap")
if not status_ok then
    return
end

local debugger_path = os.getenv "HOME" .. "/.local/share/nvim/mason/bin/OpenDebugAD7"
dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = debugger_path,
}

dap.configurations.c = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
    {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
    },
}
