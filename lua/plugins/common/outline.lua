return {
    'stevearc/aerial.nvim',
    event = "VeryLazy",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        local aerial = require('aerial')
        local rikka = require('rikka')
        local opts = {
            layout = {
                min_width = 30,
            },
            -- autojump = true,
            lsp = {
                diagnostics_trigger_update = true,

                update_when_errors = true,

                update_delay = 300,
            },

            treesitter = {
                update_delay = 300,
            },

            markdown = {
                update_delay = 300,
            },
        }
        aerial.setup(opts)
        rikka.createCommand("Outline", function()
            vim.cmd("AerialToggle")
        end, { desc = "Open File Outline" })
    end
}
