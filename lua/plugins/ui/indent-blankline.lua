-- Highlight group from rainbow-delimiters
local highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
}

return {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    branch = "v3",
    opts = {
        indent = {
            char = "¦",
            tab_char = "¦",
        },
        scope = {
            enabled = true,
            highlight = highlight,
        },
    },
    config = function(_, opts)
        local ibl = require("ibl")

        ibl.setup(opts)

        local rikka = require("rikka")

        rikka.createAutocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = "*",
            callback = function(ev)
                if vim.api.nvim_win_get_config(0).relative ~= '' then
                    ibl.update { enabled = false }
                elseif rikka.isBigFile(ev.buf) then
                    ibl.update { enabled = false }
                else
                    ibl.update { enabled = true }
                end
            end
        })

        local hooks = require "ibl.hooks"
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
}
