return {
    "kevinhwang91/nvim-bqf",
    opts = {
        preview = {
            win_height = 20,
            win_vheight = 20,
            winblend = 5,
        },
    },
    config = function(_, opts)
        require("bqf").setup(opts)
        local rikka = require("rikka")

        local customHighlightGroup = {
            BqfPreviewBorder = { fg = rikka.color.orange },
        }

        for group, opts in pairs(customHighlightGroup) do
            rikka.setHightlight(group, opts)
        end
    end,
}
