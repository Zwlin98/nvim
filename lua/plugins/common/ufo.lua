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

        local function extension(filename)
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

        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" 󰁂 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
        end

        ufo.setup({
            fold_virt_text_handler = handler,
            provider_selector = function(bufnr, filetype, buftype)
                local filename = vim.api.nvim_buf_get_name(bufnr)
                return extension(filename) or ftMap[filetype] or customizeSelector
            end,
        })

        rikka.createCommand("OpenFoldsAll", ufo.openAllFolds, { desc = "Open All Folds" })
        rikka.createCommand("CloseFoldsAll", ufo.closeAllFolds, { desc = "Close All Folds" })

        rikka.setHightlight("UfoFoldedEllipsis", { fg = rikka.color.white })
    end,
}
