return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        local rikka = require("rikka")
        require("nvim-treesitter.configs").setup({
            -- 安装 language parser
            -- :TSInstallInfo 命令查看支持的语言
            ensure_installed = {
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
                "vim",
                "yaml",
                "php",
            },
            -- 启用代码高亮功能
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = function(lang, buf)
                    return rikka.isBigFile(buf)
                end,
            },

            indent = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = "grc",
                    node_decremental = "<M-CR>",
                },
            },
        })
    end
}
