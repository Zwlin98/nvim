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
            -- Unset 'omnifunc'
            vim.bo[buffer].omnifunc = nil

            rikka.setBufKeymap(buffer, "n", "gr", lspReferences, { desc = "Check references under cursor" })
            rikka.setBufKeymap(buffer, "n", "gd", lspDefinitions, { desc = "Check definitions under cursor" })
            rikka.setBufKeymap(buffer, "n", "gi", fzf.lsp_implementations, { desc = "Check implementations under cursor" })
            rikka.setBufKeymap(buffer, "n", "ga", fzf.lsp_code_actions, { desc = "Code Actions" })
            rikka.setBufKeymap(buffer, "n", "<space>r", vim.lsp.buf.rename, { desc = "Rename" })

            rikka.setBufKeymap(buffer, "n", "gs", fzf.lsp_document_symbols, { desc = "Document Symbols" })

            vim.cmd([[nnoremap <nowait> gr gr]])
        end,
    })

    local languages = {
        "lua",
        "go",
    }

    for _, language in ipairs(languages) do
        vim.lsp.enable(language)
    end
end
