return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local trouble = require("trouble")
        local opts = {
            padding = false,
            action_keys = {
                close_folds = { "zc" },
                open_folds = { "zo" },
            },
            win_config = { border = rikka.border },
        }

        trouble.setup(opts)

        rikka.setKeymap("n", "]q", function()
            if trouble.is_open() then
                trouble.next({ skip_groups = true, jump = true })
            else
                vim.diagnostic.goto_next()
            end
        end, { desc = "Next Diagnostic or Quickfix item" })

        rikka.setKeymap("n", "[q", function()
            if trouble.is_open() then
                trouble.previous({ skip_groups = true, jump = true })
            else
                vim.diagnostic.goto_prev()
            end
        end, { desc = "Previous Diagnostic or Quickfix item" })

        rikka.setKeymap("n", "gq", function()
            if trouble.is_open() then
                trouble.close()
            else
                trouble.open("document_diagnostics")
            end
        end, { desc = "Toggle Trouble Document Diagnostics" })

        rikka.setKeymap("n", "<M-q>", function()
            if trouble.is_open() then
                trouble.close()
            else
                trouble.open("quickfix")
            end
        end, { desc = "Toggle Trouble Quickfix" })
    end,
}
