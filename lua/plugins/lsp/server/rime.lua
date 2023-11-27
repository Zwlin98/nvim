local Server = {}

function Server.checkOK()
    return true
end

function Server.setup(opts)
    local lspconfig = opts.lspconfig
    local capabilities = opts.capabilities
    local configs = require("lspconfig.configs")
    local rikka = require("rikka")

    vim.g.rime_enabled = true
    -- update lualine
    local function rime_status()
        if vim.g.rime_enabled then
            return "ㄓ"
        else
            return ""
        end
    end

    require("lualine").setup({
        sections = {
            lualine_x = { rime_status, "encoding", "fileformat", "filetype" },
        },
    })

    local rime_on_attach = function(client, bufnr)
        -- rikka.info("Rime LSP attached", "LSP")
        local toggle_rime = function()
            client.request("workspace/executeCommand", { command = "rime-ls.toggle-rime" }, function(_, result, ctx, _)
                if ctx.client_id == client.id then
                    vim.g.rime_enabled = result
                end
            end)
        end
        -- keymaps for executing command
        rikka.setBufKeymap(bufnr, "n", "<M-space>", toggle_rime, { desc = "Toggle Rime" })

        rikka.createCommand("SyncRime", function()
            vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
        end, { desc = "Sync Rime User data" })
    end

    if not configs.rime_ls then
        configs.rime_ls = {
            default_config = {
                name = "rime_ls",
                cmd = vim.lsp.rpc.connect("100.64.0.15", 9257),
                filetypes = { "*" },
                single_file_support = true,
                on_attach = rime_on_attach,
                capabilities = capabilities,
            },
            settings = {},
        }
    end

    lspconfig.rime_ls.setup({
        init_options = {
            enabled = vim.g.rime_enabled,
            trigger_characters = {},
            schema_trigger_character = "&", -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
            paging_characters = { ",", ".", "-", "=" },
        },
    })
end

return Server
