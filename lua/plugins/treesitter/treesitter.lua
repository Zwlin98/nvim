return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
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
            },
            -- 启用代码高亮功能
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = function(lang, buf)
                    local max_filesize = 1024 * 1024 -- 1MB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
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
