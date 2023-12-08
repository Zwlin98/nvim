local Server = {}

function Server.checkOK()
    return vim.fn.executable("rust-analyzer") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    lspconfig.rust_analyzer.setup({
        capabilities = opts.capabilities,
    })
end

return Server
