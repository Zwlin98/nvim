local rikka = require("rikka")
local config = function()
    vim.g.copilot_filetypes = {
        registers = 0,
    }

    vim.g.copilot_no_tab_map = true
    rikka.setKeymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, script = true, expr = true, replace_keycodes = false }
    )
end

return {
    "github/copilot.vim",
    event = "VeryLazy",
    config = config,
}
