return {
    "mbbill/undotree",
    config = function()
        local width = function()
            local columns = vim.go.columns
            return math.floor(columns * 0.15) > 25 and math.floor(columns * 0.15) or 25
        end

        vim.g.undotree_SplitWidth = width()
        vim.g.undotree_WindowLayout = 2

        vim.g.undotree_DiffAutoOpen = 0
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_HelpLine = 0
    end,
}
