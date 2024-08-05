local rikka = require("rikka")
local osc52 = require("vim.ui.clipboard.osc52")

if rikka.isRemote() and not rikka.isTmux() then
    local copy = osc52.copy("+")
    rikka.createAutocmd("TextYankPost", {
        callback = function()
            if vim.v.event.operator == "y" then
                copy(vim.v.event.regcontents)
            end
        end,
    })
else
    vim.cmd([[set clipboard+=unnamedplus]])
end
