local Server = {}

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    lspconfig.phpactor.setup {}
end

return Server
