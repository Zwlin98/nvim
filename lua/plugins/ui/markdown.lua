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
        })

        local customHighlightGroup = {
            RenderMarkdownH1Bg = { fg = rikka.color.blue, bg = "#3b4252", bold = true }, -- nord9 on nord1
            RenderMarkdownH2Bg = { fg = rikka.color.cyan, bg = "#434c5e", bold = true }, -- nord8 on nord2
            RenderMarkdownH3Bg = { fg = rikka.color.green, bg = "#3b4252", bold = true }, -- nord14 on nord1
            RenderMarkdownH4Bg = { fg = rikka.color.yellow, bg = "#434c5e", bold = true }, -- nord13 on nord2
            RenderMarkdownH5Bg = { fg = rikka.color.violet, bg = "#3b4252", bold = true }, -- nord15 on nord1
            RenderMarkdownH6Bg = { fg = rikka.color.orange, bg = "#434c5e", bold = true }, -- nord12 on nord2
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
