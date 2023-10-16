local rikka = require("rikka")

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
    opts = {
        auto_resize_height = true,
        preview = {
            border = rikka.border,
        },
    },
}
