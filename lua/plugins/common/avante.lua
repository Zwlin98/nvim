return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- 永远不要将此值设置为 "*"！永远不要！
    build = "make",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },

    config = function()
        local rikka = require("rikka")
        local avanteApi = require("avante.api")

        local opts = {
            provider = "azure",
            auto_suggestions_provider = "azure",
            azure = {
                endpoint = "https://closeai.zwlin.io", -- internal gateway of azure openai
                deployment = "gpt-4o",
                api_version = "2025-01-01-preview",
                timeout = 30000,
                temperature = 0,
                max_completion_tokens = 16384,
                reasoning_effort = "medium",
                api_key_name = { "echo", "justafakekey" },
            },
            behaviour = {
                auto_set_keymaps = true,
            },
            hints = { enabled = true },
            mappings = {
                ---@class AvanteConflictMappings
                diff = {
                    ours = "co",
                    theirs = "ct",
                    all_theirs = "ca",
                    both = "cb",
                    cursor = "cc",
                    next = "]x",
                    prev = "[x",
                },
                suggestion = {
                    accept = "<M-l>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
                jump = {
                    next = "]]",
                    prev = "[[",
                },
                submit = {
                    normal = "<CR>",
                    insert = "<C-s>",
                },
                cancel = {
                    normal = { "<C-c>", "<Esc>", "q" },
                    insert = { "<C-c>" },
                },
                -- NOTE: The following will be safely set by avante.nvim
                ask = "ga", -- Ask for a new completion
                edit = "ge", -- Edit the current completion
                sidebar = {
                    apply_all = "A",
                    apply_cursor = "a",
                    retry_user_request = "r",
                    edit_user_request = "e",
                    switch_windows = "<Tab>",
                    reverse_switch_windows = "<S-Tab>",
                    remove_file = "d",
                    add_file = "@",
                    close = { "<Esc>", "q" },
                    close_from_input = { normal = "<Esc>", insert = "<C-d>" },
                },
                files = {
                    add_current = "<leader>ac", -- Add current buffer to selected files
                    add_all_buffers = "<leader>aB", -- Add all buffer files to selected files
                },
            },
        }

        require("avante").setup(opts)

        rikka.setKeymap("n", "<M-q>", function()
            vim.cmd("AvanteToggle")
        end, { desc = "Avante: edit" })

        rikka.setKeymap("i", "<M-q>", function()
            vim.cmd("stopinsert")
            vim.cmd("AvanteToggle")
        end, { desc = "Avante: edit" })

        rikka.createCommand("ChatHistory", function()
            avanteApi.select_history()
        end, { desc = "Avante: Select History" })
    end,
}
