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

        local function copy()
            if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
                require('osc52').copy_register('+')
            end
        end

        rikka.createAutocmd('TextYankPost', { callback = copy })
    end,
}
