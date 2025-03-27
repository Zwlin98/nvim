return {
    "ggandor/leap.nvim",
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
            LeapLabelDimmed = { bg = rikka.color.lightGray, fg = rikka.color.white },
            LeapMatch = { bg = rikka.color.orange, fg = rikka.color.black },
            LeapLabel = { bg = rikka.color.green, fg = rikka.color.black },
        }

        for group, color in pairs(LeapColors) do
            rikka.setHightlight(group, color)
        end
    end,
}
