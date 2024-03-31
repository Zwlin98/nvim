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
            rikka.info("Add to pinned buffers", "Pin Buffer")
        end, { desc = "Grapple tag" })

        rikka.setKeymap("n", "<M-w>", function()
            grapple.toggle_tags()
        end, { desc = "Show pinned buffers" })

        rikka.setKeymap("n", "<M-;>", function()
            grapple.cycle_forward()
        end, { desc = "Cycle next pinned buffer" })
    end,
}
