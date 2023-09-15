local rikka = require("rikka")
return {
    'glacambre/firenvim',
    enabled = rikka.isLocal,
    build = function()
        vim.fn["firenvim#install"](0)
    end
}
