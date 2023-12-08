local Server = {}

function Server.checkOK()
    return vim.fn.executable("intelephense") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    lspconfig.intelephense.setup({
        capabilities = opts.capabilities,
    })
end

return Server
