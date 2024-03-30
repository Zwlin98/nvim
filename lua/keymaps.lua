local rikka = require("rikka")

rikka.setKeymap("v", "<", "<gv", { desc = "Left Indent" })
rikka.setKeymap("v", ">", ">gv", { desc = "Right Indent" })

rikka.setKeymap("n", "<M-c>", ":close<CR>", { desc = "Close Window" })
rikka.setKeymap("n", "<M-x>", ":tabclose<CR>", { desc = "Close Tab" })

rikka.setKeymap("n", "q:", ":q<CR>", { desc = "Quit" }) -- q: is useless and annoying
