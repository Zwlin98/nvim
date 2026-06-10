return {
    "leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim.git",
    dependencies = {
        "tpope/vim-repeat",
    },
    config = function()
        local rikka = require("rikka")
        rikka.setKeymap("n", "s", "<Plug>(leap)", { desc = "Leap" })
        rikka.setKeymap("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })

        -- LeapLabelDimmed
        -- LeapMatch
        -- LeapLabel
        local LeapColors = {
            LeapLabelDimmed = { bg = "NONE", fg = rikka.color.grayWhite, bold = true },
            LeapMatch = { bg = "NONE", fg = rikka.color.orange, bold = true },
            LeapLabel = { bg = "NONE", fg = rikka.color.green, bold = true },
        }

        for group, color in pairs(LeapColors) do
            rikka.setHightlight(group, color)
        end
    end,
}
