local rikka = require("rikka")

rikka.setKeymap("v", "<", "<gv")
rikka.setKeymap("v", ">", ">gv")

rikka.setKeymap("n", "<M-h>", ":nohlsearch<CR>")
rikka.setKeymap("v", "<M-h>", ":nohlsearch<CR>")

rikka.setKeymap('n', '[q', vim.diagnostic.goto_prev)
rikka.setKeymap('n', ']q', vim.diagnostic.goto_next)

rikka.setKeymap("n", "<M-c>", ":close<CR>")
