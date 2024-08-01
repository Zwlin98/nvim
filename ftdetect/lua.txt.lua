local rikka = require("rikka")
rikka.createAutocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.lua.txt",
    callback = function(args)
        if not rikka.isBigFile(args.buf) then
            vim.cmd("setlocal filetype=lua")
        end
    end,
})
