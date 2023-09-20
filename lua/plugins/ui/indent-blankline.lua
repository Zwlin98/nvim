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
                local function check()
                    local cfg = vim.api.nvim_win_get_config(0)
                    if cfg and cfg.relative ~= '' then
                        ibl.update { enabled = false }
                    end
                    if ev.buf and rikka.isBigFile(ev.buf) then
                        ibl.update { enabled = false }
                    else
                        ibl.update { enabled = true }
                    end
                end
                local ok = pcall(check)
                if not ok then
                    vim.notify("Failed to check indent-blankline", vim.log.levels.ERROR)
                    ibl.update { enabled = false }
                end
            end
        })

        local hooks = require "ibl.hooks"
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
}
