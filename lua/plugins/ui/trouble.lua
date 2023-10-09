return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local trouble = require("trouble")
        local opts = {
            height = 15,
        }

        trouble.setup(opts)

        rikka.setKeymap("n", "gq", function()
            trouble.open("document_diagnostics")
        end, { desc = "Trouble" })
        rikka.setKeymap("n", "gR", function()
            trouble.open("lsp_references")
        end, { desc = "Trouble" })
    end,
}
