return {
    "stevearc/stickybuf.nvim",
    event = "VeryLazy",
    config = function()
        local stickybuf = require("stickybuf")
        stickybuf.setup({
            get_auto_pin = function(bufnr)
                return stickybuf.should_auto_pin(bufnr)
            end,
        })
    end,
}
