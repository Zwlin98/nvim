local rikka = require("rikka")

if rikka.isRemote() and not rikka.isTmux() then
    vim.o.clipboard = "unnamedplus"
    vim.g.clipboard = "osc52"
else
    vim.o.clipboard = "unnamedplus"
end
