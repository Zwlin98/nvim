return {
    "EdenEast/nightfox.nvim",
    priority = 10000,
    config = function()
        local modules = {
            leap = {
                enable = false,
            }
        }
        local groups = {
            nordfox = {
                CursorLine = { bg = "#3a3944" },
            }
        }
        require('nightfox').setup({
            options = {
                modules = modules,
            },
            groups = groups
        })
        -- load the colorscheme here
        vim.cmd([[colorscheme nordfox]])
    end,
}
