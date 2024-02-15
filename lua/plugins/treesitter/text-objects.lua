return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "a function region" },
                        ["if"] = { query = "@function.inner", desc = "inner part of a function region" },
                        ["aj"] = { query = "@conditional.outer", desc = "a judge statement" },
                        ["ij"] = { query = "@conditional.inner", desc = "inner part of a judge region" },
                        ["al"] = { query = "@loop.outer", desc = "a loop statement" },
                        ["il"] = { query = "@loop.inner", desc = "inner part of a loop statement" },
                        ["ac"] = { query = "@class.outer", desc = "a class statement" },
                        ["ic"] = { query = "@class.inner", desc = "inner part of a class statement" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = { query = "@function.outer", desc = "Next function start" },
                        ["]]"] = { query = "@class.outer", desc = "Next class start" },
                    },
                    goto_previous_start = {
                        ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                        ["[["] = { query = "@class.outer", desc = "Previous class start" },
                    },
                },
            },
        })
    end,
}
