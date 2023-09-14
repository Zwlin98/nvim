local rikka = require("rikka")

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or rikka.border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "aznhe21/actions-preview.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        local telescope = require("telescope.builtin")

        vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
            callback = function(env)
                if vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint(env.buf, false)
                end
            end,
        })
        vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
            callback = function(env)
                if vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint(env.buf, true)
                end
            end,
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(env)
                local keyOpts = { buffer = env.buf }
                rikka.setKeymap('n', 'gr', telescope.lsp_references, keyOpts)
                rikka.setKeymap("n", "gd", telescope.lsp_definitions, keyOpts)
                rikka.setKeymap("n", "gi", telescope.lsp_implementations, keyOpts)
                rikka.setKeymap({ "v", "n" }, "ga", require("actions-preview").code_actions)
                rikka.setKeymap("n", "K", vim.lsp.buf.hover, keyOpts)
                rikka.setKeymap("n", "<space>r", vim.lsp.buf.rename, keyOpts)
                rikka.setKeymap("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, keyOpts)
                rikka.setKeymap("v", "<space>f", function() vim.lsp.buf.format({ async = true }) end, keyOpts)
            end,
        })

        local lspOpts = {
            capabilities = capabilities,
            lspconfig = lspconfig,
        }

        local servers = {
            "luals",
            "intelephense",
            "gopls",
            "rust_analyzer",
        }

        for _, server in ipairs(servers) do
            local serverModule = rikka.prequire("plugins.lsp.server." .. server)
            if serverModule and serverModule.checkOK() then
                serverModule.setup(lspOpts)
            else
                vim.notify("LSP server " .. server .. " not OK", vim.log.levels.WARN)
            end
        end
    end
}
