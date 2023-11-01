return {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        rikka.createCommand("Gb", function()
            vim.cmd("Git blame --date=short")
        end, { desc = "Git Blame" })
    end,
}
