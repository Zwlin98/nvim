local rikka = require("rikka")
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        local opts = {
            popup_border_style = rikka.border,
            filesystem = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
            }
        }
        local neotree = require("neo-tree")

        neotree.setup(opts)

        rikka.setKeymap("n", "<space>e", ":Neotree toggle<CR>", { desc = "Open NeoTree" })
    end
}
