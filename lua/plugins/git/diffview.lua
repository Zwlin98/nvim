return {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        rikka.createCommand("His", function()
            vim.cmd("DiffviewFileHistory %")
        end, { desc = "File History (Using Diffview)" })
    end
}
