local Server = {}

function Server.checkOK()
    return vim.fn.executable("pyright") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig

    lspconfig.pyright.setup({
        capabilities = opts.capabilities,
    })
end

return Server
