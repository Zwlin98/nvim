local rikka = require("rikka")

rikka.createAutocmd({ "VimEnter" }, {
    command = "clearjumps",
})

rikka.createAutocmd({ "FileType" }, {
    command = "set formatoptions-=ro",
})

rikka.createAutocmd("TermOpen", {
    pattern = "*",
    callback = function()
        rikka.setBufKeymap(0, "n", "<ESC>", "<CMD>close<CR>", { desc = "Clse Terminal" })
        rikka.setBufKeymap(0, "t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Terminal Mode Swich Window" })
    end,
})

rikka.createAutocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_on_yank", {}),
    desc = "Briefly highlight yanked text",
    callback = function()
        vim.highlight.on_yank({ higroup = "YankPost", timeout = 300 })
    end,
})
