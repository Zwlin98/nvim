return {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
        "nvim-tree/nvim-web-devicons",
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    config = function()
        local opts = {
            keymap = {
                preset = "enter",
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                list = {
                    selection = { preselect = false, auto_insert = true },
                },
                documentation = { auto_show = false },
                menu = {
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local lspkind = require("lspkind")
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = require("lspkind").symbolic(ctx.kind, {
                                            mode = "symbol",
                                        })
                                    end

                                    return icon .. ctx.icon_gap
                                end,

                                -- Optionally, use the highlight groups from nvim-web-devicons
                                -- You can also add the same function for `kind.highlight` if you want to
                                -- keep the highlight groups in sync with the icons.
                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            },
                        },
                    },
                },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    cmdline = {
                        min_keyword_length = function(ctx)
                            -- when typing a command, only show when the keyword is 3 characters or longer
                            if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                                return 3
                            end
                            return 0
                        end,
                    },
                },
            },

            cmdline = {
                keymap = {
                    ["<Tab>"] = {
                        function(cmp)
                            if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
                                return cmp.accept()
                            end
                        end,
                        "show_and_insert",
                        "select_next",
                    },
                    ["<Down>"] = { "select_next", "fallback" },
                    ["<Up>"] = { "select_prev", "fallback" },
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        }

        require("blink.cmp").setup(opts)
    end,
}
