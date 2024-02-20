return {
    "github/copilot.vim",
    event = "VeryLazy",
    init = function()
        vim.g.copilot_no_tab_map = true
    end,
    config = function()
        local rikka = require("rikka")

        rikka.setKeymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { desc = "Copilot Accept", expr = true, replace_keycodes = false })

        local function autoDisable()
            local disabled
            return function()
                if disabled then
                    return
                end
                if DISABLE_COPILOT then
                    vim.cmd("Copilot disable")
                    disabled = true
                end
            end
        end

        -- create .nvim.lua with content `DISABLE_COPILOT=true` in project root to disable copilot
        rikka.createAutocmd("BufEnter", {
            pattern = "*",
            callback = autoDisable(),
        })
    end,
}
