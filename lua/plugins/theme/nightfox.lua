return {
    "EdenEast/nightfox.nvim",
    priority = 10000,
    config = function()
        local palettes = {
            nordfox = {
                bg0 = "#2e3440", -- Dark bg (status line and float)
                bg1 = "#2e3440", -- Default bg
                bg2 = "#39404f", -- Lighter bg (colorcolm folds)
                bg3 = "#444c5e", -- Lighter bg (cursor line)
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
    end,
}
