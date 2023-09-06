return {
    "github/copilot.vim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        vim.g.copilot_filetypes = {
            registers = 0,
        }

        vim.g.copilot_no_tab_map = true

        rikka.setKeymap("i", "<M-j>", 'copilot#Accept("<CR>")',
            { silent = true, script = true, expr = true, replace_keycodes = false }
        )
    end,
}
