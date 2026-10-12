return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            dim_inactive = { enabled = false },
        })
        vim.cmd.colorscheme("catppuccin")

        local rikka = require("rikka")
        local customHighlightGroup = {
            WinSeparator = { fg = rikka.color.cursorGray },

            Folded = { fg = nil, bg = nil },

            DiagnosticVirtualTextError = { fg = rikka.color.red, bg = nil },
            DiagnosticVirtualTextWarn = { fg = rikka.color.yellow, bg = nil },
            DiagnosticVirtualTextInfo = { fg = rikka.color.orange, bg = nil },
            DiagnosticVirtualTextHint = { fg = rikka.color.green, bg = nil },
            DiagnosticVirtualTextOk = { fg = rikka.color.blue, bg = nil },

            LspInlayHint = { fg = rikka.color.grayWhite, bg = nil, italic = true },

            Pmenu = { bg = rikka.color.black },
            PmenuThumb = { bg = rikka.color.cursorGray },

            Visual = { bg = rikka.color.visualGray, fg = nil },
            VisualNOS = { bg = rikka.color.visualGrayDim, fg = nil },

            YankPost = { bg = rikka.color.yankGray, fg = nil },

            NormalFloat = { bg = nil },
            FloatBorder = { bg = nil },
        }
        for group, opts in pairs(customHighlightGroup) do
            rikka.setHightlight(group, opts)
        end
    end,
}
