return {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
        local fidget = require("fidget")
        local rikka = require("rikka")
        fidget.setup()
        vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
            -- local client = vim.lsp.get_client_by_id(ctx.client_id)
            local level = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
            fidget.notify(rikka.wrapMsg(result.message), level)
        end
    end,
}
