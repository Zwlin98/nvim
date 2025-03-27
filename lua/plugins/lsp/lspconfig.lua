return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local rikka = require("rikka")
        local lspconfig = require("lspconfig")
        local fzf = require("fzf-lua")

        -- Change diagnostic symbols in the sign column (gutter)
        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        local function lspReferences()
            fzf.lsp_references({
                ignore_current_line = true,
            })
        end

        local function lspDefinitions()
            fzf.lsp_definitions({
                sync = true,
                jump1 = true,
            })
        end

        rikka.createAutocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then
                    return
                end

                if client:supports_method("textDocument/inlayHints") then
                    vim.lsp.inlay_hint.enable()
                end

                local buffer = args.buf

                rikka.setBufKeymap(buffer, "n", "gr", lspReferences, { desc = "Check references under cursor" })
                rikka.setBufKeymap(buffer, "n", "gd", lspDefinitions, { desc = "Check definitions under cursor" })
                rikka.setBufKeymap(buffer, "n", "gi", fzf.lsp_implementations, { desc = "Check implementations under cursor" })
                rikka.setBufKeymap(buffer, "n", "ga", fzf.lsp_code_actions, { desc = "Code Actions" })
                rikka.setBufKeymap(buffer, "n", "<space>r", vim.lsp.buf.rename, { desc = "Rename" })

                rikka.setBufKeymap(buffer, "n", "gs", fzf.lsp_document_symbols, { desc = "Document Symbols" })

                vim.cmd([[nnoremap <nowait> gr gr]])
            end,
        })

        local lspOpts = {
            lspconfig = lspconfig,
        }

        local servers = {
            "c",
            -- "go",
            -- "lua",
            "rust",
            "python",
        }

        for _, server in ipairs(servers) do
            local serverModule = rikka.prequire("plugins.lsp.server." .. server)
            if serverModule and serverModule.checkOK() then
                serverModule.setup(lspOpts)
            else
                if rikka.notifyLSPError() then
                    rikka.warn("The lsp server " .. server .. " not found", "LSP ERROR")
                end
            end
        end
    end,
}
