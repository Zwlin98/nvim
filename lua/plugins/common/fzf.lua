return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        local fzfPath = require("fzf-lua.path")
        local rikka = require("rikka")
        local fzfActions = require("fzf-lua.actions")

        local customActions = {}

        function customActions.openWithCode(selected)
            if rikka.isRemote() then
                return
            end
            local entry = fzfPath.entry_to_file(selected[1])
            if entry.path == "<none>" then
                return
            end
            local line = entry.line or 1
            local col = entry.col or 1
            local vscodePathFormat = string.format("%s:%s:%s", entry.path, line, col)
            vim.system({ "code", "--goto", vscodePathFormat })
        end

        function customActions.makeSmartVsplit(options)
            -- options.ignored_filetypes should be a set/table, eg { aerial=true, NvimTree=true, ... }

            local ignored_filetypes = options and options.ignored_filetypes or {
                aerial = true,
            }

            -- helper: 获取所有可见窗口
            local function get_visible_windows()
                local visible = {}
                local function traverse(layout)
                    if type(layout) ~= "table" then
                        return
                    end
                    if layout[1] == "leaf" then
                        table.insert(visible, layout[2])
                    else
                        for i = 2, #layout do
                            traverse(layout[i])
                        end
                    end
                end
                traverse(vim.fn.winlayout())
                return visible
            end

            -- 这是闭包函数
            return function(selected, opts)
                if #selected ~= 1 then
                    return
                end

                local sourceWin = tonumber(opts.__CTX.winid)
                if not sourceWin or not vim.api.nvim_win_is_valid(sourceWin) then
                    return
                end

                local wins = get_visible_windows()
                local targetWins = {}
                for _, win in ipairs(wins) do
                    local cfg = vim.api.nvim_win_get_config(win)
                    if win ~= sourceWin and cfg.relative == "" then
                        local bufnr = vim.api.nvim_win_get_buf(win)
                        local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
                        if not ignored_filetypes[ft] then
                            table.insert(targetWins, win)
                        end
                    end
                end

                if #targetWins ~= 1 then
                    return fzfActions.file_vsplit(selected, opts)
                end

                local targetWin = targetWins[1]
                local entry = fzfPath.entry_to_file(selected[1])

                vim.api.nvim_set_current_win(targetWin)
                vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
                if entry.line and entry.line > 0 then
                    vim.api.nvim_win_set_cursor(targetWin, { math.max(1, entry.line), math.max(0, (entry.col or 1) - 1) })
                end
            end
        end

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

            actions = {
                ["ctrl-o"] = customActions.openWithCode,
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
            tabs = cfgSmall,
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
                    true,
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    true,
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                },
            },
            grep = {
                rg_opts = table.concat(rgOpts, " "),
                actions = {
                    ["ctrl-o"] = customActions.openWithCode,
                },
            },
            actions = {
                files = {
                    ["default"] = fzfActions.file_edit_or_qf,
                    ["ctrl-s"] = fzfActions.file_split,
                    ["ctrl-v"] = customActions.makeSmartVsplit(),
                    ["ctrl-t"] = fzfActions.file_tabedit,
                    ["alt-q"] = fzfActions.file_sel_to_qf,
                },
            },
        })

        fzf.register_ui_select()

        rikka.setKeymap("n", "<M-p>", fzf.builtin, { desc = "FzfLua builtin" })
        rikka.setKeymap("n", "<M-e>", fzf.files, { desc = "Find Files with fzf" })
        rikka.setKeymap("n", "<M-r>", fzf.buffers, { desc = "Find Buffers with fzf" })
        rikka.setKeymap("n", "<M-t>", fzf.tabs, { desc = "Find Tabs with fzf" })

        rikka.setKeymap("n", "<M-`>", fzf.lsp_document_symbols, { desc = "Document Symbols(FzfLua)" })

        rikka.setKeymap("n", "<M-s>", fzf.blines, { desc = "Fzf current buffer lines" })

        rikka.setKeymap("v", "<M-s>", function()
            local vstart, vend = rikka.getCurrentSelectionRange()
            fzf.blines({ start_line = vstart, end_line = vend })
        end, { desc = "Fzf current buffer lines" })

        rikka.setKeymap("n", "?", function()
            fzf.grep_curbuf({ search = rikka.getCurrrentWord() })
        end, { desc = "Grep word in current buffer" })

        rikka.setKeymap("v", "?", function()
            fzf.grep_curbuf({ search = rikka.getVisualSelection() })
        end, { desc = "Grep visual selection in current buffer" })

        rikka.setKeymap("n", "<M-g>", fzf.grep_cword, { desc = "Grep Cword" })

        rikka.setKeymap("v", "<M-g>", fzf.grep_visual, { desc = "Grep visual selection" })

        rikka.setKeymap("n", "<C-h>", function()
            fzf.git_bcommits({
                winopts = {
                    height = 0.9,
                    preview = {
                        layout = "vertical",
                        vertical = "up:70%",
                    },
                },
            })
        end, { desc = "FzfLua Git file Commits history" })

        rikka.setKeymap("n", "gf", function()
            fzf.files({ query = rikka.getCurrrentWord() })
        end, { desc = "FzfLua Goto file" })

        rikka.setKeymap("n", "ge", fzf.diagnostics_document, { desc = "FzfLua Document Diagnostics" }) -- goto error

        rikka.setKeymap("n", "<M-z>", fzf.jumps, { desc = "FzfLua Jumplist" })

        rikka.setKeymap("n", "<M-f>", fzf.live_grep_native, { desc = "FzfLua Live Grep" })

        rikka.setKeymap("n", "<C-.>", fzf.resume, { desc = "Fzflua resume last command/query" })
    end,
}
