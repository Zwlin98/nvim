return {
    'stevearc/aerial.nvim',
    event = "VeryLazy",
    opts = {
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
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
}
