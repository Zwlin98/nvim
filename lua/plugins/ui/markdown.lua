return {
    "MeanderingProgrammer/render-markdown.nvim",
    config = function()
        local rikka = require("rikka")
        require("render-markdown").setup({
            completions = { blink = { enabled = true } },
            file_types = { "markdown", "Avante" },
            code = {
                border = "thin",
                above = "-",
                -- Used below code blocks for thin border.
                below = "-",
            },
        })

        local customHighlightGroup = {
            RenderMarkdownCode = { bg = rikka.color.black },
            RenderMarkdownCodeBorder = { fg = rikka.color.blue },
        }

        for group, opts in pairs(customHighlightGroup) do
            rikka.setHightlight(group, opts)
        end
    end,
}
