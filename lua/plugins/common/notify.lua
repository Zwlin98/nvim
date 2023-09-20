return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        local notify = require "notify"
        notify.setup({
            timeout = 1000,
        })
        vim.notify = notify
    end,
}
