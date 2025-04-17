return {
    "github/copilot.vim",
    init = function()
        vim.g.copilot_no_tab_map = true
    end,
    config = function()
        local rikka = require("rikka")

        rikka.setKeymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { desc = "Copilot Accept", expr = true, replace_keycodes = false })
    end,
}
