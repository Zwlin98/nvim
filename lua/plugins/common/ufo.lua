return {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
        "nvim-lspconfig",
        "kevinhwang91/promise-async",
    },
    config = function()
        vim.o.foldcolumn = "0" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local ufo = require("ufo")
        local promise = require("promise")
        local rikka = require("rikka")

        local ftMap = {
            vim = "indent",
            git = "",
        }

        local suffixMap = {
            ["lua.txt"] = "indent",
        }

        local function suffix(filename)
            for k, v in pairs(suffixMap) do
                if string.sub(filename, -string.len(k)) == k then
                    return v
                end
            end
        end

        local function customizeSelector(bufnr)
            local function handleFallbackException(err, providerName)
                if type(err) == "string" and err:match("UfoFallbackException") then
                    return ufo.getFolds(bufnr, providerName)
                else
                    return promise.reject(err)
                end
            end

            return ufo.getFolds(bufnr, "lsp")
                :catch(function(err)
                    return handleFallbackException(err, "treesitter")
                end)
                :catch(function(err)
                    return handleFallbackException(err, "indent")
                end)
        end

        ufo.setup({
            provider_selector = function(bufnr, filetype, buftype)
                local filename = vim.api.nvim_buf_get_name(bufnr)
                return suffix(filename) or ftMap[filetype] or customizeSelector
            end,
        })

        rikka.createCommand("OpenFoldsAll", ufo.openAllFolds, { desc = "Open All Folds" })
        rikka.createCommand("CloseFoldsAll", ufo.closeAllFolds, { desc = "Close All Folds" })

        rikka.setHightlight("UfoFoldedEllipsis", { fg = rikka.color.white })
    end,
}
