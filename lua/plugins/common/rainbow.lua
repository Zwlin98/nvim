return {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
        local rainbow_delimiters = require 'rainbow-delimiters'

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
