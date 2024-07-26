return {
    "sindrets/diffview.nvim",
    config = function()
        local rikka = require("rikka")

        rikka.createCommand("FileHistory", function()
            vim.cmd("DiffviewFileHistory %")
        end, { desc = "view file history" })
    end,
}
