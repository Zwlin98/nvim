return {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
        local rainbow = require("rainbow-delimiters")
        local rikka = require("rikka")

        local rainbowHighlight = {
            RainbowDelimiterRed = { fg = rikka.color.red },
            RainbowDelimiterOrange = { fg = rikka.color.orange },
            RainbowDelimiterYellow = { fg = rikka.color.yellow },
            RainbowDelimiterViolet = { fg = rikka.color.violet },
            RainbowDelimiterGreen = { fg = rikka.color.green },
            RainbowDelimiterCyan = { fg = rikka.color.cyan },
            RainbowDelimiterBlue = { fg = rikka.color.blue },
        }

        for group, opts in pairs(rainbowHighlight) do
            rikka.setHightlight(group, opts)
        end

        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = function(bufnr)
                    if rikka.isBigFile(bufnr) then
                        return nil
                    end
                    return rainbow.strategy["global"]
                end,
            },
            query = {
                [""] = "rainbow-delimiters",
                lua = "rainbow-blocks",
            },
            highlight = {
                "RainbowDelimiterOrange",
                "RainbowDelimiterYellow",
                "RainbowDelimiterViolet",
                "RainbowDelimiterGreen",
                "RainbowDelimiterCyan",
                "RainbowDelimiterBlue",
                "RainbowDelimiterRed",
            },
            blacklist = { "c", "cpp" },
        }
    end,
}
