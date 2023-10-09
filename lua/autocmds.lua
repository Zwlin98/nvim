local rikka = require("rikka")

rikka.createAutocmd({ "VimEnter" }, {
    command = "clearjumps",
})

rikka.createAutocmd({ "FileType" }, {
    command = "set formatoptions-=ro",
})
