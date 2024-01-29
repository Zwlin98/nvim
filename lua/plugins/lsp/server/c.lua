local Server = {}

function Server.checkOK()
    return vim.fn.executable("clangd") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    local capabilities = vim.deepcopy(opts.capabilities)
    capabilities.offsetEncoding = "utf-8"
    lspconfig.clangd.setup({
        capabilities = capabilities,
        filetypes = { "c", "cpp", "h" },
    })
end

return Server
