return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter")
        local wanted = {
            "bash",
            "c",
            "go",
            "json",
            "kdl",
            "lua",
            "markdown",
            "markdown_inline",
            "proto",
            "regex",
            "rust",
            "yaml",
            "php",
            "beancount",
            "comment",
            "vim",
            "vimdoc",
            "html",
        }
        treesitter.install(wanted)
    end,
}
