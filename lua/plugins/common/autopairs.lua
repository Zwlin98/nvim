return {
    "saghen/blink.pairs",
    version = "*", -- (recommended) only required with prebuilt binaries
    -- download prebuilt binaries from github releases
    dependencies = "saghen/blink.download",
    opts = {
        highlights = {
            enabled = true,
            groups = {
                "BlinkPairsBlue", -- third level
                "BlinkPairsOrange", -- second level
                "BlinkPairsPurple", -- fisrt level
            },
        },
    },
    config = function(_, opts)
        require("blink.pairs").setup(opts)

        local rikka = require("rikka")
        local customHighlightGroup = {
            BlinkPairsBlue = { fg = "#8FBCBB", bg = nil },
            BlinkPairsOrange = { fg = rikka.color.orange, bg = nil },
            BlinkPairsPurple = { fg = rikka.color.violet, bg = nil },
        }

        for group, colorOpts in pairs(customHighlightGroup) do
            rikka.setHightlight(group, colorOpts)
        end
    end,
}
