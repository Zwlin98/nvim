return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local trouble = require("trouble")
        local opts = {
            height = 15,
            padding = false,
            action_keys = {
                close_folds = { "zc" },
                open_folds = { "zo" },
            },
            win_config = { border = rikka.border },
        }

        trouble.setup(opts)

        rikka.setKeymap("n", "gq", function()
            trouble.open("document_diagnostics")
        end, { desc = "Trouble" })

        rikka.setKeymap("n", "<M-q>", function()
            if trouble.is_open() then
                trouble.close()
                return
            end
            trouble.toggle("quickfix")
        end, { desc = "Trouble Quickfix" })
    end,
}
