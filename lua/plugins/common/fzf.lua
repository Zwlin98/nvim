return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        local fzf = require("fzf-lua")
        local rikka = require("rikka")

        local cfgSmall = {
            -- previewer = false,
            winopts = {
                width = 0.4,
                height = 0.6,
                col = 0.5,
                row = 0.35,
                preview = {
                    layout = "vertical",
                    vertical = "up:60%",
                },
            },
            fzf_opts = {
                ["--layout"] = "reverse",
            },
        }

        fzf.setup({
            files = cfgSmall,
            buffers = cfgSmall,
            fzf_opts = {
                ["--layout"] = "default",
            },
            fzf_colors = {
                ["bg+"] = { "bg", "CursorLine" },
                ["gutter"] = { "bg", "Normal" },
            },
        })

        rikka.setKeymap("n", "<M-p>", fzf.builtin, { desc = "FzfLua builtin" })
        rikka.setKeymap("n", "<M-e>", fzf.files, { desc = "Find Files with fzf" })
        rikka.setKeymap("n", "<M-r>", fzf.buffers, { desc = "Find Buffers with fzf" })

        rikka.setKeymap("n", "<M-`>", fzf.lsp_document_symbols, { desc = "Document Symbols(FzfLua)" })

        rikka.setKeymap("n", "<M-s>", fzf.lgrep_curbuf, { desc = "Fzf " })

        rikka.setKeymap("n", "?", function()
            fzf.lgrep_curbuf({ search = rikka.getCurrrentWord() })
        end, { desc = "Grep word in current buffer" })

        rikka.setKeymap("v", "?", function()
            fzf.lgrep_curbuf({ search = rikka.getVisualSelection() })
        end, { desc = "Grep visual selection in current buffer" })

        rikka.setKeymap("n", "<M-g>", fzf.grep_cword, { desc = "Grep Cword" })

        rikka.setKeymap("v", "<M-g>", fzf.grep_visual, { desc = "Grep visual selection" })

        rikka.setKeymap("n", "gf", function()
            fzf.files({ search = rikka.getCurrrentWord() })
        end, { desc = "FzfLua Goto file" })

        rikka.setKeymap("n", "<M-z>", fzf.jumps, { desc = "FzfLua Jumplist" })

        rikka.setKeymap("n", "<M-f>", fzf.live_grep_native, { desc = "FzfLua Live Grep" })
    end,
}
