local rikka = require("rikka")

rikka.setKeymap("v", "<", "<gv", { desc = "Left Indent" })
rikka.setKeymap("v", ">", ">gv", { desc = "Right Indent" })

rikka.setKeymap("n", "<M-h>", ":nohlsearch<CR>", { desc = "No Highlight" })
rikka.setKeymap("v", "<M-h>", ":nohlsearch<CR>", { desc = "No Highlight" })

rikka.setKeymap('n', '[q', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
rikka.setKeymap('n', ']q', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

rikka.setKeymap("n", "<M-c>", ":close<CR>", { desc = "Close" })
