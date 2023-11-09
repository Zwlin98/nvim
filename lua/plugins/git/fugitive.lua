return {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        rikka.createCommand("Gb", function()
            vim.cmd("Git blame --date=short")
        end, { desc = "Git Blame" })

        rikka.setKeymap("n", "<M-m>", ":Git blame  --date=short<CR>", { desc = "Git Blame" })
    end,
}
