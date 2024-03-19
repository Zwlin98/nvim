return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "aznhe21/actions-preview.nvim",
    },
    config = function()
        local rikka = require("rikka")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        local telescope = require("telescope.builtin")
        local actions_preview = require("actions-preview")
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
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or rikka.border
            local bufnr, winnr = lspUtilOpenFloatingPreview(contents, syntax, opts, ...)
            if bufnr then
                vim.api.nvim_win_set_option(winnr, "winblend", 20)
            end
        end

        rikka.createAutocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(env)
                local buffer = env.buf
                rikka.setBufKeymap(buffer, "n", "gr", telescope.lsp_references, { desc = "Check references under cursor" })
                rikka.setBufKeymap(buffer, "n", "gd", telescope.lsp_definitions, { desc = "Check definitions under cursor" })
                rikka.setBufKeymap(buffer, "n", "gi", telescope.lsp_implementations, { desc = "Check implementations under cursor" })
                rikka.setBufKeymap(buffer, "n", "H", vim.lsp.buf.hover, { desc = "Lsp Hover" })
                rikka.setBufKeymap(buffer, "n", "ga", actions_preview.code_actions, { desc = "Code Actions" })
                rikka.setBufKeymap(buffer, "n", "<space>r", vim.lsp.buf.rename, { desc = "Rename" })

                rikka.setBufKeymap(buffer, "n", "gs", telescope.lsp_document_symbols, { desc = "Document Symbols" })

                rikka.setBufKeymap(buffer, "n", "[d", function()
                    vim.diagnostic.goto_prev({ float = false })
                end, { desc = "Previous Diagnostic" })
                rikka.setBufKeymap(buffer, "n", "]d", function()
                    vim.diagnostic.goto_next({ float = false })
                end, { desc = "Next Diagnostic" })
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
            "php",
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
