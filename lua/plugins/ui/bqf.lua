return {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
        {
            "junegunn/fzf",
            build = function()
                vim.fn["fzf#install"]()
            end,
        },
    },
    config = function()
        local rikka = require("rikka")
        local opts = {
            auto_resize_height = true,
            preview = {
                border = rikka.border,
            },
            -- make `drop` and `tab drop` to become preferred
            func_map = {
                fzffilter = "?",
                filter = "<C-q>",
            },
        }

        require("bqf").setup(opts)
    end,
}
