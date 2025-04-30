return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    config = function()
        local markdown = require("render-markdown")
        local rikka = require("rikka")
        markdown.setup({
            heading = {
                sign = false,
                position = "inline",
            },
            code = {
                width = "block",
            },
        })

        local customHighlightGroup = {

            RenderMarkdownH1Bg = { bg = nil },
            RenderMarkdownH2Bg = { bg = nil },
            RenderMarkdownH3Bg = { bg = nil },
            RenderMarkdownH4Bg = { bg = nil },
            RenderMarkdownH5Bg = { bg = nil },
            RenderMarkdownH6Bg = { bg = nil },
        }

        vim.iter(customHighlightGroup):each(function(group, opts)
            rikka.setHightlight(group, opts)
        end)
    end,
}
