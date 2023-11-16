local rikka = require("rikka")

rikka.setKeymap("v", "<", "<gv", { desc = "Left Indent" })
rikka.setKeymap("v", ">", ">gv", { desc = "Right Indent" })

rikka.setKeymap("n", "[q", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
rikka.setKeymap("n", "]q", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

rikka.setKeymap("n", "<M-c>", ":close<CR>", { desc = "Close Window" })
rikka.setKeymap("n", "<M-x>", ":tabclose<CR>", { desc = "Close Tab" })
