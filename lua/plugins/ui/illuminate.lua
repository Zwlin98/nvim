return {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local illuminate = require("illuminate")
        illuminate.configure({
            filetypes_denylist = {
                "aerial",
                "help",
                "git",
                "markdown",
                "snippets",
                "text",
                "gitconfig",
                "alpha",
                "dashboard",
            },
            modes_allowlist = { "n" },

            large_file_cutoff = 10240,
        })

        -- Highlight on yank
        -- conflict with vim-illuminate
        local customHighlightGroup = {
            YankPost = { bg = "#7480A1", fg = nil },
            IlluminatedWordText = { bg = rikka.color.noVisualGray },
            IlluminatedWordRead = { bg = rikka.color.gray },
            IlluminatedWordWrite = { bg = rikka.color.lightGray },
        }

        for group, opts in pairs(customHighlightGroup) do
            rikka.setHightlight(group, opts)
        end

        rikka.setKeymap("n", "gn", function()
            illuminate.goto_next_reference()
        end, { desc = "Goto Next reference" })

        rikka.setKeymap("n", "gp", function()
            illuminate.goto_prev_reference()
        end, { desc = "Goto Prev reference" })
    end,
}
