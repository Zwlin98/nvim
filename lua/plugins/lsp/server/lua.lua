local Server = {}

function Server.checkOK()
    return vim.fn.executable("lua-language-server") == 1
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig

    lspconfig.lua_ls.setup({
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. "/.luarc.json") and vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    library = { vim.env.VIMRUNTIME },
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end,
        capabilities = opts.capabilities,
        settings = {
            Lua = {
                hint = {
                    enable = true,
                },
            },
        },
    })
end

return Server
