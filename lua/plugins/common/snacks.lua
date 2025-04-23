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
        notifier = {
            enabled = true,
            timeout = 2000, -- default timeout in ms
            style = "fancy",
        },
        words = { enabled = true },
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
                        cursor = true,
                        edge = true,
                        treesitter = { blocks = { enabled = true } },
                        desc = "jump to top edge of scope",
                    },
                    ["]s"] = {
                        min_size = 2, -- allow single line scopes
                        bottom = true,
                        cursor = true,
                        edge = true,
                        treesitter = { blocks = { enabled = true } },
                        desc = "jump to bottom edge of scope",
                    },
                },
            },
        },
    },
    keys = {
        {
            "gn",
            function()
                Snacks.words.jump(vim.v.count1)
            end,
            desc = "Next Reference",
            mode = { "n", "t" },
        },
        {
            "gp",
            function()
                Snacks.words.jump(-vim.v.count1)
            end,
            desc = "Prev Reference",
            mode = { "n", "t" },
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
