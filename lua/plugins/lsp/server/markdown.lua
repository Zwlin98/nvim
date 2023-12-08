local Server = {}

function Server.checkOK()
    return vim.fn.executable("marksman") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    lspconfig.marksman.setup({
        capabilities = opts.capabilities,
    })
end

return Server
