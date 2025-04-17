return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local conform = require("conform")

        local opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                json = { "jq" },
                yaml = { "yamlfmt" },
                markdown = { "autocorrect" },
                python = function(bufnr)
                    if require("conform").get_formatter_info("ruff_format", bufnr).available then
                        return { "ruff_format" }
                    else
                        return { "isort", "black" }
                    end
                end,
                proto = { "clang-format" },
                zsh = { "shfmt" },
                bash = { "shfmt" },
            },
        }

        conform.formatters.jq = {
            prepend_args = { "--indent", "4" },
        }

        conform.setup(opts)

        local function format()
            conform.format({ async = true, lsp_fallback = true })
        end

        local function formatCJK(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            conform.format({ formatters = { "autocorrect" }, async = true, range = range })
        end

        rikka.createCommand("FormatCJK", formatCJK, { desc = "Format CJK Text", range = true })

        rikka.setKeymap("n", "<space>f", format, { desc = "Format Documents" })
        rikka.setKeymap("v", "<space>f", format, { desc = "Format Selection" })
    end,
}
