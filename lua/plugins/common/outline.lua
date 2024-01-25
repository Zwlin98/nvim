return {
    "hedyhli/outline.nvim",
    event = "VeryLazy",
    config = function()
        local outline = require("outline")
        local rikka = require("rikka")

        outline.setup()

        rikka.setKeymap("n", "<leader>o", "<CMD>Outline<CR>", { desc = "Toggle File Outline" })
    end,
}
