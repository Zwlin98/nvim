return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        quickfile = { enabled = true },
        input = {
            enabled = true,
            win = {
                relative = "cursor",
                row = 1,
            },
        },
        dashboard = {
            preset = {
                header = [[
                                                                 
                                                                 
         ██████╗ ███████╗███╗   ███╗ █████╗ ██╗███╗   ██╗        
         ██╔══██╗██╔════╝████╗ ████║██╔══██╗██║████╗  ██║        
         ██████╔╝█████╗  ██╔████╔██║███████║██║██╔██╗ ██║        
         ██╔══██╗██╔══╝  ██║╚██╔╝██║██╔══██║██║██║╚██╗██║        
         ██║  ██║███████╗██║ ╚═╝ ██║██║  ██║██║██║ ╚████║        
         ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝        
                                                                 
 ███████╗███████╗ █████╗ ██████╗ ██╗     ███████╗███████╗███████╗
 ██╔════╝██╔════╝██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝██╔════╝
 █████╗  █████╗  ███████║██████╔╝██║     █████╗  ███████╗███████╗
 ██╔══╝  ██╔══╝  ██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║╚════██║
 ██║     ███████╗██║  ██║██║  ██║███████╗███████╗███████║███████║
 ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝
                                                                 
                                                                 
       Consider everything deeply but still remain fearless.     
                                                                 
                                                                 
                             Zwlin's NVIM                        ]],
                keys = {
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "e", desc = "Find File", action = "<cmd>FzfLua files<CR>" },
                    { icon = " ", key = "f", desc = "Live Grep", action = "<cmd>FzfLua live_grep_native<CR>" },
                    { icon = "󰒲 ", key = "s", desc = "Lazy", action = "<cmd>Lazy<CR>", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
                },
            },
            enabled = true,
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
            },
        },
        notifier = {
            enabled = true,
            timeout = 2000, -- default timeout in ms
            style = "fancy",
        },
        statuscolumn = {
            enabled = true,
            right = { "git" }, -- priority of signs on the right (high to low)

            folds = {
                open = false, -- show open fold icons
                git_hl = true, -- use Git Signs hl for fold icons
            },
        },
        scope = {
            enabled = true,
            treesitter = {
                blocks = {
                    enabled = true,
                },
            },
            keys = {
                ---@type table<string, snacks.scope.TextObject|{desc?:string}>
                textobject = {
                    is = {
                        min_size = 2, -- minimum size of the scope
                        edge = false, -- inner scope
                        cursor = false,
                        treesitter = { blocks = { enabled = false } },
                        desc = "inner scope",
                    },
                    as = {
                        cursor = false,
                        min_size = 2, -- minimum size of the scope
                        treesitter = { blocks = { enabled = false } },
                        desc = "full scope",
                    },
                },
                ---@type table<string, snacks.scope.Jump|{desc?:string}>
                jump = {
                    ["[s"] = {
                        min_size = 2, -- allow single line scopes
                        bottom = false,
                        cursor = false,
                        edge = true,
                        treesitter = { blocks = { enabled = true } },
                        desc = "jump to top edge of scope",
                    },
                    ["]s"] = {
                        min_size = 2, -- allow single line scopes
                        bottom = true,
                        cursor = false,
                        edge = true,
                        treesitter = { blocks = { enabled = true } },
                        desc = "jump to bottom edge of scope",
                    },
                },
            },
        },
    },
    config = function(_, opts)
        local rikka = require("rikka")
        local snacks = require("snacks")
        snacks.setup(opts)

        rikka.setKeymap("n", "<C-g>", function()
            snacks.lazygit({ win = { border = "rounded", backdrop = false } })
        end, { desc = "Toggle Lazygit" })
    end,
}
