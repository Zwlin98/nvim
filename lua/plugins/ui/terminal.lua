return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")

        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.3
                end
            end,
            shade_terminals = false,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        local normalTerminal = Terminal:new({
            cmd = vim.o.shell,
            dir = vim.fn.expand("%:p:h"),
            direction = "float",
            on_open = function(term)
                vim.cmd("startinsert!")
                rikka.setBufKeymap(0, "t", "<ESC>", [[<C-\><C-n>]], { desc = "Enter Normal Mode" })
                rikka.setBufKeymap(term.bufnr, "t", "<C-`>", "<cmd>close<CR>", { desc = "Close Terminal" })
            end,
        })
        rikka.setKeymap("n", "<C-`>", function()
            normalTerminal:toggle()
        end, { desc = "Toggle Terminal" })

    end,
}
