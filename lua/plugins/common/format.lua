return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
        local opts = {
            formatters_by_ft = {
                lua = { "stylua" },
            },
        }
        local rikka = require("rikka")
        local conform = require("conform")

        conform.setup(opts)

        local function format()
            conform.format({ async = true, lsp_fallback = true })
        end

        rikka.setKeymap("n", "<space>f", format, { desc = "Format Documents" })
        rikka.setKeymap("v", "<space>f", format, { desc = "Format Selection" })
    end,
}
