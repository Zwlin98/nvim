return {
    "EdenEast/nightfox.nvim",
    priority = 10000,
    config = function()
        require('nightfox').setup({
            options = {
                modules = {
                    leap = {
                        enable = false,
                    }
                }
            }
        })
        -- load the colorscheme here
        vim.cmd([[colorscheme nordfox]])
    end,
}
