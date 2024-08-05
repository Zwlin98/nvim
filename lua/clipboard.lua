local rikka = require("rikka")

if rikka.isRemote() and not rikka.isTmux() then
    local osc52 = require("vim.ui.clipboard.osc52")

    vim.o.clipboard = "unnamedplus"

    local function paste()
        return {
            vim.fn.split(vim.fn.getreg(""), "\n"),
            vim.fn.getregtype(""),
        }
    end

    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = osc52.copy("+"),
            ["*"] = osc52.copy("*"),
        },
        paste = {
            ["+"] = paste,
            ["*"] = paste,
        },
    }
else
    vim.o.clipboard = "unnamedplus"
end
