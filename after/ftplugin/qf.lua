local rikka = require("rikka")

rikka.setBufKeymap(0, "n", "q", ":cclose<CR>", { desc = "Close quickfix" })
