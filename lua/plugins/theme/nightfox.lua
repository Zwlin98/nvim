return {
    "EdenEast/nightfox.nvim",
    priority = 10000,
    config = function()
        local rikka = require("rikka")
        local palettes = {
            nordfox = {
                bg0 = rikka.color.black,
                bg1 = rikka.color.black,
                bg2 = "#39404f", -- Lighter bg (colorcolm folds)
                bg3 = "#373E4F", -- Lighter bg (cursor line)
                bg4 = "#5a657d", -- Conceal, border fg

                fg0 = "#c7cdd9", -- Lighter fg
                fg1 = "#cdcecf", -- Default fg
                fg2 = "#abb1bb", -- Darker fg (status line)
                fg3 = "#7e8188", -- Darker fg (line numbers, fold colums)

                sel0 = "#5a657d", -- Popup bg, visual selection bg
                sel1 = "#4f6074", -- Popup sel bg, search bg
            },
        }
        local modules = {
            leap = {
                enable = false,
            },
        }
        require("nightfox").setup({
            palettes = palettes,
            options = {
                modules = modules,
            },
        })

        -- load the colorscheme here
        vim.cmd([[colorscheme nordfox]])

        local customHighlightGroup = {
            WinSeparator = { fg = rikka.color.cursorGray },

            Folded = { fg = nil, bg = nil },

            DiagnosticVirtualTextError = { fg = rikka.color.red, bg = nil },
            DiagnosticVirtualTextWarn = { fg = rikka.color.yellow, bg = nil },
            DiagnosticVirtualTextInfo = { fg = rikka.color.orange, bg = nil },
            DiagnosticVirtualTextHint = { fg = rikka.color.green, bg = nil },
            DiagnosticVirtualTextOk = { fg = rikka.color.blue, bg = nil },
        }

        for group, opts in pairs(customHighlightGroup) do
            rikka.setHightlight(group, opts)
        end
    end,
}
