return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[         ██████╗ ███████╗███╗   ███╗ █████╗ ██╗███╗   ██╗         ]],
            [[         ██╔══██╗██╔════╝████╗ ████║██╔══██╗██║████╗  ██║         ]],
            [[         ██████╔╝█████╗  ██╔████╔██║███████║██║██╔██╗ ██║         ]],
            [[         ██╔══██╗██╔══╝  ██║╚██╔╝██║██╔══██║██║██║╚██╗██║         ]],
            [[         ██║  ██║███████╗██║ ╚═╝ ██║██║  ██║██║██║ ╚████║         ]],
            [[         ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝         ]],
            [[                                                                  ]],
            [[ ███████╗███████╗ █████╗ ██████╗ ██╗     ███████╗███████╗███████╗ ]],
            [[ ██╔════╝██╔════╝██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝██╔════╝ ]],
            [[ █████╗  █████╗  ███████║██████╔╝██║     █████╗  ███████╗███████╗ ]],
            [[ ██╔══╝  ██╔══╝  ██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║╚════██║ ]],
            [[ ██║     ███████╗██║  ██║██║  ██║███████╗███████╗███████║███████║ ]],
            [[ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝ ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[     Consider everything deeply but still remain fearless.        ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                         Zwlin's NVIM                             ]],
            [[                                                                  ]],
            [[                                                                  ]],
            [[                                                                  ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("r", "  > Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("e", "󰈞  > Find files", ":Telescope find_files<CR>"),
            dashboard.button("f", "  > Live Grep", ":Telescope live_grep<CR>"),
            dashboard.button("t", "  > Todos", ":TodoTelescope<CR>"),
            dashboard.button("s", "  > Lazy Status", ":Lazy<CR>"),
            dashboard.button("q", "󰙧  > Quit NVIM", ":qa<CR>"),
        }

        dashboard.section.footer = {
            [[ Consider everything deeply but still remain fearless. ]],
        }

        alpha.setup(dashboard.opts)
    end,
}
