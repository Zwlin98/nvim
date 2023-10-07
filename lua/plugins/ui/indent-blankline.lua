return {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
        local ibl = require("ibl")
        local rikka = require("rikka")

        ibl.setup {
            indent = {
                char = "¦",
                tab_char = "¦",
            },
        }
    end,
}
