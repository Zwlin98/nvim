return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local trouble = require("trouble")

        trouble.setup()

        rikka.setKeymap("n", "]q", function()
            if trouble.is_open() then
                trouble.next({ skip_groups = true, jump = true })
            else
                vim.diagnostic.goto_next({ float = false })
            end
        end, { desc = "Next Diagnostic or Quickfix item" })

        rikka.setKeymap("n", "[q", function()
            if trouble.is_open() then
                trouble.previous({ skip_groups = true, jump = true })
            else
                vim.diagnostic.goto_prev({ float = false })
            end
        end, { desc = "Previous Diagnostic or Quickfix item" })

        rikka.setKeymap("n", "gq", function()
            if trouble.is_open() then
                trouble.close()
            else
                trouble.open({
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = { buf = 0 }, -- filter diagnostics to the current buffer
                })
            end
        end, { desc = "Toggle Trouble Document Diagnostics" })

        rikka.setKeymap("n", "<C-q>", function()
            if trouble.is_open() then
                trouble.close()
            else
                trouble.open("fzf")
            end
        end, { desc = "Toggle Trouble Quickfix" })
    end,
}
