return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        local gitsigns = require("gitsigns")
        gitsigns.setup({

            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 500,
                ignore_whitespace = true,
                virt_text_priority = 100,
            },

            preview_config = {
                -- Options passed to nvim_open_win
                border = rikka.border,
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },

            on_attach = function(bufnr)
                -- Navigation
                rikka.setBufKeymap(bufnr, "n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next", { target = "all" })
                    end
                end, { desc = "Next change" })

                rikka.setBufKeymap(bufnr, "n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev", { target = "all" })
                    end
                end)
            end,
        })

        rikka.setHightlight("GitSignsCurrentLineBlame", { fg = rikka.color.blameGray })

        rikka.createCommand("PreviewDiff", function()
            gitsigns.preview_hunk()
        end, { desc = "Gitsigns Preview Hunk" })
    end,
}
