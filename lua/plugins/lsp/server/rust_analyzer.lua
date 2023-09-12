local Server = {}

function Server.setup(opts)
    local lspconfig = require('lspconfig')
    lspconfig.rust_analyzer.setup {}
end

return Server
