return {
    "nvim-lua/plenary.nvim",
    config = function()
        local profile = require("plenary.profile")
        local rikka = require("rikka")

        rikka.createCommand("StartProfile", function()
            profile.start("profile.log", { flame = true })
        end, { desc = "Start profiling" })

        rikka.createCommand("StopProfile", function()
            profile.stop()
        end, { desc = "Stop profiling" })
    end,
}
