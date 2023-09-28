local rikka = require("rikka")

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
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
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        local telescope = require("telescope.builtin")

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

        rikka.createAutocmd("LspAttach", {
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
            "clangd",
        }

        for _, server in ipairs(servers) do
            local serverModule = rikka.prequire("plugins.lsp.server." .. server)
            if serverModule and serverModule.checkOK() then
                serverModule.setup(lspOpts)
            else
                rikka.warn("The lsp server " .. server .. " not found", "LSP ERROR")
            end
        end
    end
}
