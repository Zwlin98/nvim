return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local rikka = require("rikka")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        local fzf = require("fzf-lua")
        local win = require("lspconfig.ui.windows")

        win.default_options.border = rikka.border

        -- Change diagnostic symbols in the sign column (gutter)
        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- Override floating window settings
        local lspUtilOpenFloatingPreview = vim.lsp.util.open_floating_preview
        ---@diagnostic disable-next-line: duplicate-set-field
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or rikka.border
            lspUtilOpenFloatingPreview(contents, syntax, opts, ...)
            -- local bufnr, winnr = lspUtilOpenFloatingPreview(contents, syntax, opts, ...)
            -- if bufnr then
            --     vim.api.nvim_win_set_var(winnr, "winblend", 10)
            -- end
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

                if client.supports_method("textDocument/inlayHints") then
                    vim.lsp.inlay_hint.enable()
                end

                local buffer = args.buf

                rikka.setBufKeymap(buffer, "n", "gr", lspReferences, { desc = "Check references under cursor" })
                rikka.setBufKeymap(buffer, "n", "gd", lspDefinitions, { desc = "Check definitions under cursor" })
                rikka.setBufKeymap(buffer, "n", "gi", fzf.lsp_implementations, { desc = "Check implementations under cursor" })
                rikka.setBufKeymap(buffer, "n", "ga", fzf.lsp_code_actions, { desc = "Code Actions" })
                rikka.setBufKeymap(buffer, "n", "<space>r", vim.lsp.buf.rename, { desc = "Rename" })

                rikka.setBufKeymap(buffer, "n", "gs", fzf.lsp_document_symbols, { desc = "Document Symbols" })
            end,
        })

        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local lspOpts = {
            capabilities = capabilities,
            lspconfig = lspconfig,
        }

        local servers = {
            "c",
            "go",
            "lua",
            "markdown",
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
