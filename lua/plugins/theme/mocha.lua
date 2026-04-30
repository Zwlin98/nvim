return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            dim_inactive = { enabled = false },
            integrations = {
                fzf = true,
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                native_lsp = true,
                noice = true,
                which_key = true,
                barbecue = { dim = false },
                mason = true,
                neotree = true,
                semantic_tokens = true,
                illuminate = true,
                blink_cmp = true,
                mini = true,
            },
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

            YankPost = { bg = rikka.color.cursorGray, fg = nil },

            NormalFloat = { bg = nil },
            FloatBorder = { bg = nil },
        }
        for group, opts in pairs(customHighlightGroup) do
            rikka.setHightlight(group, opts)
        end
    end,
}
