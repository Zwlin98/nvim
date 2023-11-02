return {
    "echasnovski/mini.indentscope",
    event = "VeryLazy",
    config = function()
        local indentscope = require("mini.indentscope")
        local rikka = require("rikka")

        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = rikka.color.gray })

        indentscope.setup()
    end,
}
