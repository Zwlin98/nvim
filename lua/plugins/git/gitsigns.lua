return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")
        require("gitsigns").setup({

            current_line_blame = true,

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                -- Navigation (diff)
                rikka.setBufKeymap(bufnr, "n", "]d", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Gitsigns Next Hunk" })

                rikka.setBufKeymap(bufnr, "n", "[d", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Gitsigns Prev Hunk" })
            end,
        })

        rikka.createCommand("PreviewDiff", function()
            vim.cmd("Gitsigns preview_hunk")
        end, { desc = "Gitsigns Preview Hunk" })
    end,
}
