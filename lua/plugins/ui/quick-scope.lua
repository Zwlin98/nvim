-- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

return {
    "unblevable/quick-scope",
    config = function()
        local rikka = require("rikka")

        vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = "#D5FF80", underline = true })
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = "#73DDFF", underline = true })

        vim.g.qs_filetype_blacklist = { "help", "dashboard", "NvimTree", "alpha" }
        vim.g.qs_buftype_blacklist = { "terminal", "nofile", "prompt" }
    end,
}
