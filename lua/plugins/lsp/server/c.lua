local Server = {}

function Server.checkOK()
    return vim.fn.executable("clangd") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    lspconfig.clangd.setup({})
end

return Server