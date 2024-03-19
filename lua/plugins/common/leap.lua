return {
    "ggandor/leap.nvim",
    dependencies = {
        "tpope/vim-repeat",
    },
    config = function()
        local rikka = require("rikka")
        rikka.setKeymap("n", "s", "<Plug>(leap)", { desc = "Leap" })
        rikka.setKeymap("n", "S", "<Plug>(leap-krom-window)", { desc = "Leap from window" })
    end,
}
