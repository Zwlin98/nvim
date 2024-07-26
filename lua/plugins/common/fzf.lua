return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        local actions = require("trouble.sources.fzf").actions

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
                backdrop = 100,
            },
            fzf_opts = {
                ["--layout"] = "reverse",
            },
        }

        local rgOpts = {
            "--color=always",
            "--colors=match:fg:0xD0,0x87,0x70",
            "--column",
            "--line-number",
            "--no-heading",
            "--smart-case",
            "--max-columns=4096",
            "-e",
        }

        fzf.setup({
            files = cfgSmall,
            buffers = cfgSmall,
            fzf_opts = {
                ["--layout"] = "default",
            },

            winopts = {
                backdrop = 100,
            },

            fzf_colors = {
                ["fg"] = { "fg", "Normal" },
                ["bg"] = { "bg", "Normal" },
                ["fg+"] = { "fg", "CursorLine" },
                ["bg+"] = { "bg", "CursorLine" },
                ["hl+"] = { "fg", "Statement" },
                ["info"] = { "fg", "PreProc" },
                ["border"] = { "fg", "Ignore" },
                ["prompt"] = { "fg", "Conditional" },
                ["pointer"] = { "fg", "Exception" },
                ["marker"] = { "fg", "Keyword" },
                ["spinner"] = { "fg", "Label" },
                ["header"] = { "fg", "Comment" },
                ["gutter"] = { "bg", "Normal" },
            },
            hls = {
                header_text = "DiagnosticError",
            },
            keymap = {
                builtin = {
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
            },
            grep = {
                rg_opts = table.concat(rgOpts, " "),
                actions = {
                    ["ctrl-q"] = actions.open,
                },
            },
        })

        fzf.register_ui_select()

        rikka.setKeymap("n", "<M-p>", fzf.builtin, { desc = "FzfLua builtin" })
        rikka.setKeymap("n", "<M-e>", fzf.files, { desc = "Find Files with fzf" })
        rikka.setKeymap("n", "<M-r>", fzf.buffers, { desc = "Find Buffers with fzf" })

        rikka.setKeymap("n", "<M-`>", fzf.lsp_document_symbols, { desc = "Document Symbols(FzfLua)" })

        rikka.setKeymap("n", "<M-s>", fzf.blines, { desc = "Fzf current buffer lines" })

        rikka.setKeymap("n", "?", function()
            fzf.grep_curbuf({ search = rikka.getCurrrentWord() })
        end, { desc = "Grep word in current buffer" })

        rikka.setKeymap("v", "?", function()
            fzf.grep_curbuf({ search = rikka.getVisualSelection() })
        end, { desc = "Grep visual selection in current buffer" })

        rikka.setKeymap("n", "<M-g>", fzf.grep_cword, { desc = "Grep Cword" })

        rikka.setKeymap("v", "<M-g>", fzf.grep_visual, { desc = "Grep visual selection" })

        rikka.setKeymap("n", "gf", function()
            fzf.files({ query = rikka.getCurrrentWord() })
        end, { desc = "FzfLua Goto file" })

        rikka.setKeymap("n", "<M-z>", fzf.jumps, { desc = "FzfLua Jumplist" })

        rikka.setKeymap("n", "<M-f>", fzf.live_grep_native, { desc = "FzfLua Live Grep" })
    end,
}
