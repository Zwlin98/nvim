return {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")
        local rikka = require("rikka")

        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = rikka.color.red })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = rikka.color.orange })
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = rikka.color.yellow })
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = rikka.color.violet })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = rikka.color.green })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = rikka.color.cyan })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = rikka.color.blue })


        vim.g.rainbow_delimiters = {
            strategy = {
                [''] = rainbow_delimiters.strategy['global'],
                commonlisp = rainbow_delimiters.strategy['local'],
            },
            query = {
                [''] = 'rainbow-delimiters',
                lua = 'rainbow-blocks',
            },
            highlight = {
                'RainbowDelimiterOrange',
                'RainbowDelimiterYellow',
                'RainbowDelimiterViolet',
                'RainbowDelimiterGreen',
                'RainbowDelimiterCyan',
                'RainbowDelimiterBlue',
                'RainbowDelimiterRed',
            },
            blacklist = { 'c', 'cpp' },
        }
    end
}
