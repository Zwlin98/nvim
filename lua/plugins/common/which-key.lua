return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local opts = {
            win = {
                border = rikka.border,
            },
            layout = {
                height = { min = 10, max = 25 },
            },
            triggers = {
                { "<leader>", mode = "n", "v" },
                { "<C-r>", mode = "i", "v" },
            },
        }
        local wk = require("which-key")
        wk.setup(opts)
    end,
}
