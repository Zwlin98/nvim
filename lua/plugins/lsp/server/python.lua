local Server = {}

function Server.checkOK()
    return vim.fn.executable("pyright") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    local capabilities = opts.capabilities

    lspconfig.pyright.setup({})
end

return Server
