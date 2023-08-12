local status_ok, conflict = pcall(require, "git-conflict")
if not status_ok then
    return
end

conflict.setup()
