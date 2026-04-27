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
                width = "block",
                min_width = 80,
            },
            code = {
                width = "block",
                highlight_border = false,
            },
            latex = {
                enabled = false,
            },
        })

        local customHighlightGroup = {
            RenderMarkdownH1Bg = { fg = rikka.color.blue, bg = rikka.color.lightBlack, bold = true },
            RenderMarkdownH2Bg = { fg = rikka.color.cyan, bg = rikka.color.gray, bold = true },
            RenderMarkdownH3Bg = { fg = rikka.color.green, bg = rikka.color.lightBlack, bold = true },
            RenderMarkdownH4Bg = { fg = rikka.color.yellow, bg = rikka.color.gray, bold = true },
            RenderMarkdownH5Bg = { fg = rikka.color.violet, bg = rikka.color.lightBlack, bold = true },
            RenderMarkdownH6Bg = { fg = rikka.color.orange, bg = rikka.color.gray, bold = true },
            RenderMarkdownCode = {},
            RenderMarkdownCodeBorder = {},
            RenderMarkdownCodeInfo = {},
            RenderMarkdownCodeFallback = {},
            RenderMarkdownCodeInline = {},
        }
        vim.iter(customHighlightGroup):each(function(group, opts)
            rikka.setHightlight(group, opts)
        end)
    end,
}
