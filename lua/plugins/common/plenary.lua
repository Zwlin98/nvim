return {
    "nvim-lua/plenary.nvim",
    config = function()
        local profile = require("plenary.profile")
        local rikka = require("rikka")

        rikka.createCommand("ProfileStart", function()
            profile.start("profile.log", { flame = true })
        end, { desc = "Start profiling" })

        rikka.createCommand("ProfileStop", function()
            profile.stop()
        end, { desc = "Stop profiling" })
    end,
}
