return {
    "sindrets/diffview.nvim",
    config = function()
        local rikka = require("rikka")

        local diffview = require("diffview")

        diffview.setup({
            enhanced_diff_hl = true,
        })

        rikka.createCommand("FileHistory", function()
            vim.cmd("DiffviewFileHistory %")
        end, { desc = "view file history" })
    end,
}
