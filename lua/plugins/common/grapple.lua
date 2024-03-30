return {
    "cbochs/grapple.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    config = function()
        local grapple = require("grapple")
        local rikka = require("rikka")
        grapple.setup({
            win_opts = {
                border = rikka.border,
            },
        })

        rikka.setKeymap("n", "<M-a>", function()
            grapple.tag()
            rikka.info("Add to Pinned Buffers", "Grapple")
        end, { desc = "Grapple tag" })

        rikka.setKeymap("n", "<M-w>", function()
            grapple.toggle_tags()
        end, { desc = "Grapple toggle tags" })
    end,
}
