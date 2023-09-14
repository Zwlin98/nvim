local rikka = require("rikka")

rikka.createAutocmd({ "VimEnter" }, {
    command = "clearjumps",
})
