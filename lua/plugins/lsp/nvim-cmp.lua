return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "neovim/nvim-lspconfig",
        "onsails/lspkind-nvim",
        "saadparwaiz1/cmp_luasnip",
        "windwp/nvim-autopairs",
    },
    event = {
        "InsertEnter",
        "CmdlineEnter",
    },
    config = function()
        local rikka = require("rikka")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        local autopairs = require("nvim-autopairs")

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")

        local cmpHighlight = {
            CmpNormal = { bg = rikka.color.black },

            CmpItemAbbrDeprecated = { bg = nil, strikethrough = true, fg = rikka.color.gray },
            CmpItemAbbrMatch = { bg = nil, fg = rikka.color.blue },
            CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },

            CmpItemKindVariable = { bg = nil, fg = rikka.color.cyan },
            CmpItemKindInterface = { link = "CmpItemKindVariable" },
            CmpItemKindText = { link = "CmpItemKindVariable" },
            CmpItemKindFunction = { bg = nil, fg = rikka.color.blue },
            CmpItemKindMethod = { link = "CmpItemKindFunction" },
            CmpItemKindKeyword = { bg = nil, fg = rikka.color.purple },
            CmpItemKindProperty = { link = "CmpItemKindKeyword" },
            CmpItemKindUnit = { link = "CmpItemKindKeyword" },
        }

        for group, opts in pairs(cmpHighlight) do
            rikka.setHightlight(group, opts)
        end

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        autopairs.setup()
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        cmp.setup({
            window = {
                completion = {
                    border = rikka.border,
                    winhighlight = "Normal:CmpNormal",
                    col_offset = -3,
                },
                documentation = {
                    border = rikka.border,
                },
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
                { name = "calc" },
            }),
            mapping = {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            cmp.confirm()
                        end
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                }),
                ["<Down>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<Up>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "s" }),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "s" }),
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text", -- show only symbol annotations
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                }),
            },
        })

        cmp.setup.cmdline(":", {
            mapping = {
                ["<Tab>"] = {
                    c = function()
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            cmp.complete()
                        end
                    end,
                },
                ["<S-Tab>"] = {
                    c = function()
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            cmp.complete()
                        end
                    end,
                },
                ["<Down>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                },
                ["<Up>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                },
                ["<C-e>"] = {
                    c = cmp.mapping.abort(),
                },
                ["<CR>"] = {
                    c = cmp.mapping.confirm({ select = false }),
                },
            },
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
}
