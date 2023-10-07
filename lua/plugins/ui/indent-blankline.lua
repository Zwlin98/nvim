return {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
        local ibl = require("ibl")
        local hooks = require("ibl.hooks")
        local rikka = require("rikka")

        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = rikka.color.blue })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = rikka.color.cyan })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = rikka.color.green })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = rikka.color.orange })
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = rikka.color.red })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = rikka.color.violet })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = rikka.color.yellow })
        end)

        ibl.setup {
            indent = {
                highlight = highlight,
                char = "¦",
                tab_char = "¦",
            },
        }
    end,
}
