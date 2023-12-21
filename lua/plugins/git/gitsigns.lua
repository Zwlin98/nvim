return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        require("gitsigns").setup({

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
                local gs = package.loaded.gitsigns

                rikka.setBufKeymap(bufnr, "n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, desc = "Next change" })

                rikka.setBufKeymap(bufnr, "n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, desc = "Previous change" })

                rikka.setBufKeymap(bufnr, "n", "K", gs.preview_hunk, { desc = "Preview Hunk" })
            end,
        })

        rikka.setHightlight("GitSignsCurrentLineBlame", { fg = rikka.color.blameGray })

        rikka.createCommand("PreviewDiff", function()
            vim.cmd("Gitsigns preview_hunk")
        end, { desc = "Gitsigns Preview Hunk" })
    end,
}
