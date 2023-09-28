return {
    "kevinhwang91/nvim-hlslens",
    config = function()
        local rikka = require("rikka")
        require('hlslens').setup()


        rikka.setKeymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], { desc = "Next Match" })
        rikka.setKeymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], { desc = "Previous Match" })


        rikka.setKeymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search text under cursor forwards" })
        rikka.setKeymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search text under cursor backwards" })
        rikka.setKeymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search text under cursor forwards (contains)" })
        rikka.setKeymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search text under cursor backwards (contains)" })
    end
}
