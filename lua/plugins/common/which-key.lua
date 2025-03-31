return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local opts = {
            preset = "helix",
            win = {
                border = rikka.border,
            },
            triggers = {
                { "<leader>", mode = { "n", "v" } },
                { "<C-r>", mode = { "i" } },
                { "g", mode = "n" },
                { "[", mode = { "n", "v" } },
                { "]", mode = { "n", "v" } },
            },
        }
        local wk = require("which-key")
        wk.setup(opts)
    end,
}
