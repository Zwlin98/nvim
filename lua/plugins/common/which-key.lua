return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    enabled = false,
    config = function()
        local rikka = require("rikka")
        local opts = {
            window = {
                border = rikka.border,
            },
            layout = {
                height = { min = 10, max = 25 },
            },
        }
        local wk = require("which-key")
        wk.setup(opts)
    end,
}
