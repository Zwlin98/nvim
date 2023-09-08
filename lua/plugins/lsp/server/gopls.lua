local Server = {}

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    local capabilities = opts.capabilities


    lspconfig.gopls.setup {
        capabilities = capabilities,
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
            },
        },
        init_options = {
            usePlaceholders = true,
        }
    }
end

return Server
