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

        -- rikka.createAutocmd({ 'InsertEnter' }, {
        --     callback = function(env)
        --         if vim.lsp.inlay_hint then
        --             vim.lsp.inlay_hint(env.buf, false)
        --         end
        --     end,
        -- })
        -- rikka.createAutocmd({ 'InsertLeave' }, {
        --     callback = function(env)
        --         if vim.lsp.inlay_hint then
        --             vim.lsp.inlay_hint(env.buf, true)
        --         end
        --     end,
        -- })

        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or rikka.border
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        rikka.createAutocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(env)
                local buffer = env.buf
                rikka.setBufKeymap(buffer, "n", "gr", telescope.lsp_references, { desc = "Check references under cursor" })
                rikka.setBufKeymap(buffer, "n", "gd", telescope.lsp_definitions, { desc = "Check definitions under cursor" })
                rikka.setBufKeymap(buffer, "n", "gi", telescope.lsp_implementations, { desc = "Check implementations under cursor" })
                rikka.setBufKeymap(buffer, "n", "K", vim.lsp.buf.hover, { desc = "Hover" })
                rikka.setBufKeymap(buffer, "n", "ga", actions_preview.code_actions, { desc = "Code Actions" })
                rikka.setBufKeymap(buffer, "n", "<space>r", vim.lsp.buf.rename, { desc = "Rename" })
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
