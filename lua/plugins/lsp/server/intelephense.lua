local Server = {}

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    lspconfig.intelephense.setup {}
end

return Server
