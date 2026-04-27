-- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

return {
    "unblevable/quick-scope",
    config = function()
        local rikka = require("rikka")

        rikka.setHightlight("QuickScopePrimary", { fg = rikka.color.green, underline = true })
        rikka.setHightlight("QuickScopeSecondary", { fg = rikka.color.cyan, underline = true })

        vim.g.qs_filetype_blacklist = { "help", "dashboard", "NvimTree", "alpha" }
        vim.g.qs_buftype_blacklist = { "terminal", "nofile", "prompt" }
    end,
}
