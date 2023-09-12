return {
    'akinsho/toggleterm.nvim',
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")

        require("toggleterm").setup {
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            float_opts = {
                border = rikka.border,
            },
        }


        local function set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], opts)
            vim.keymap.set('n', '<ESC>', "<CMD>close<CR>", opts)
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end

        rikka.createAutocmd("TermOpen", {
            pattern = "*",
            callback = function()
                set_terminal_keymaps()
            end
        })

        local Terminal = require('toggleterm.terminal').Terminal

        local normalTerminal = Terminal:new({
            cmd = vim.o.shell,
            dir = vim.fn.expand("%:p:h"),
            direction = "float",
            float_opts = {
                border = rikka.border,
            },
            on_open = function(term)
                vim.cmd("startinsert!")
                local _ = term
            end,
        })

        rikka.setKeymap("n", "<M-t>", function() normalTerminal:toggle() end, { noremap = true, silent = true })

        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = rikka.border,
            },

            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
        })

        local function lazygit_toggle()
            lazygit:toggle()
        end

        rikka.createCommand("Lg", lazygit_toggle, {})
    end
}