return {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local illuminate = require("illuminate")
        illuminate.configure({})

        -- Highlight on yank
        -- conflict with vim-illuminate
        vim.api.nvim_set_hl(0, "YankPost", { bg = rikka.color.green })

        rikka.createAutocmd("TextYankPost", {
            group = vim.api.nvim_create_augroup("highlight_on_yank", {}),
            desc = "Briefly highlight yanked text",
            callback = function()
                illuminate.pause()
                vim.highlight.on_yank({higroup = "YankPost", timeout = 500 })
                illuminate.resume()
            end,
        })

        rikka.setKeymap("n", "gn", function()
            illuminate.goto_next_reference()
        end, { desc = "Goto Next reference" })

        rikka.setKeymap("n", "gp", function()
            illuminate.goto_prev_reference()
        end, { desc = "Goto Prev reference" })
    end,
}
