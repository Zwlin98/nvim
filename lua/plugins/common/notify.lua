return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        local notify = require "notify"
        vim.notify = notify
    end,
}
