if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
else
    local rikka = require("rikka")
    local fzf = require("fzf-lua")

    vim.lsp.config("*", {
        root_markers = { ".git" },
    })

    vim.diagnostic.config({
        virtual_text = { current_line = true },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
                [vim.diagnostic.severity.INFO] = " ",
                [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
        },
    })

    local supportMethodSetups = {
        ["textDocument/completion"] = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then
                return
            end
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
        end,
        ["textDocument/codeAction"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "ga", fzf.lsp_code_actions, { desc = "Code Actions" })
        end,
        ["textDocument/definition"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "gd", function()
                fzf.lsp_definitions({
                    sync = true,
                    jump1 = true,
                })
            end, { desc = "Check definitions under cursor" })
        end,
        ["textDocument/inlayHints"] = function(args)
            vim.lsp.inlay_hint.enable()
        end,
        ["textDocument/implementation"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "gi", fzf.lsp_implementations, { desc = "Check implementations under cursor" })
        end,
        ["callHierarchy/incomingCalls"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "g(", fzf.lsp_incoming_calls, { desc = "Check incoming calls under cursor" })
        end,
        ["callHierarchy/outgoingCalls"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "g)", fzf.lsp_outgoing_calls, { desc = "Check outgoing calls under cursor" })
        end,
        ["textDocument/documentSymbol"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "gs", fzf.lsp_document_symbols, { desc = "Document Symbols" })
        end,
        ["textDocument/rename"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "<space>r", vim.lsp.buf.rename, { desc = "Rename" })
        end,
        ["textDocument/references"] = function(args)
            rikka.setBufKeymap(args.buf, "n", "gr", function()
                fzf.lsp_references({
                    ignore_current_line = true,
                })
            end, { desc = "Check references under cursor" })
        end,
    }

    rikka.createAutocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then
                return
            end
            for method, func in pairs(supportMethodSetups) do
                if client:supports_method(method) then
                    func(args)
                end
            end
        end,
    })

    local languages = {
        "lua",
        "go",
        "c",
    }

    for _, language in ipairs(languages) do
        vim.lsp.enable(language)
    end
end
