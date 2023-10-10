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
                        ["ar"] = { query = "@return.outer", desc = "a return" },
                        ["ir"] = { query = "@return.outer", desc = "inner return" },
                        ["aj"] = { query = "@conditional.outer", desc = "a judge" },
                        ["ij"] = { query = "@conditional.inner", desc = "inner part of a judge region" },
                        ["al"] = { query = "@loop.outer", desc = "a loop" },
                        ["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = { query = "@function.outer", desc = "Next function start" },
                        ["]r"] = { query = "@function.outer", desc = "Next return start" },
                        ["1j"] = { query = "@conditional.outer", desc = "Next judge start" },
                        ["1l"] = { query = "@loop.outer", desc = "Next loop start" },
                    },
                    goto_previous_start = {
                        ["[a"] = { query = "@parameter.outer", desc = "Previous argument start" },
                        ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                        ["[r"] = { query = "@function.outer", desc = "Previous return start" },
                        ["2j"] = { query = "@conditional.outer", desc = "Previous judge start" },
                        ["2l"] = { query = "@loop.outer", desc = "Previous loop start" },
                    },
                },
            },
        })
    end,
}
