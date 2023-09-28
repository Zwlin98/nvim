local rikka = require("rikka")
return {
    "ojroques/nvim-osc52",
    enabled = rikka.isRemote,
    config = function()
        local osc52 = require("osc52")

        osc52.setup {
            max_length = 0,     -- Maximum length of selection (0 for no limit)
            silent     = true,  -- Disable message on successful copy
            trim       = false, -- Trim surrounding whitespaces before copy
        }

        rikka.setKeymap('n', '<C-y>', osc52.copy_operator, { expr = true })
        rikka.setKeymap('v', '<C-y>', osc52.copy_visual)
    end,
}
