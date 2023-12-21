return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        local notify = require("notify")
        notify.setup({
            timeout = 1000,
            background_colour = "#000000"
        })
        vim.notify = notify
    end,
}
