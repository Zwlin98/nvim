return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            version = "^1.0.0",
        },
        {
            "nvim-telescope/telescope-frecency.nvim"
        },
        {
            "kkharji/sqlite.lua"
        }

    },
    config = function()
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")

        local dropdownConfig = {
            theme = "dropdown",
        }

        local cursorConfig = {
            theme = "cursor",
            layout_config = {
                width = 0.6,
                height = 0.4,
            },
        }

        local opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close
                    },
                },
            },
            pickers = {
                find_files = dropdownConfig,
                buffers = dropdownConfig,
                lsp_references = cursorConfig,
                lsp_definitions = cursorConfig,
                lsp_implementations = cursorConfig,
            },
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                live_grep_args = {
                    auto_quoting = true,
                    mappings = { -- extend mappings
                        i = {
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                        },
                    },
                }
            }
        }

        require("telescope").setup(opts)
        require('telescope').load_extension('fzf')
        require("telescope").load_extension("live_grep_args")
        require("telescope").load_extension("frecency")
    end
}
