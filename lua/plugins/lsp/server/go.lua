local Server = {}

function Server.checkOK()
    return vim.fn.executable("gopls") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig

    lspconfig.gopls.setup({
        capabilities = opts.capabilities,
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
                hints = {
                    assignVariableTypes = false,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
        init_options = {
            usePlaceholders = true,
        },
    })
end

return Server
