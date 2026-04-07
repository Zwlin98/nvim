local customModule = {
    "ui2",
    "gitConflict",
}

for _, module in pairs(customModule) do
    local modulePath = "custom." .. module
    local ok, err = pcall(require, modulePath)
    if not ok then
        vim.notify("Failed to load module: " .. module .. "\nError: " .. err, vim.log.levels.ERROR)
    end
end
