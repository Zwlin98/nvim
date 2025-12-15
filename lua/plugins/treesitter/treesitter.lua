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
            "python",
        }

        treesitter.install(wanted)

        local languages = {}
        for _, lang in ipairs(wanted) do
            languages[lang] = true
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter.setup", {}),
            callback = function(args)
                local buf = args.buf
                local filetype = args.match

                local language = vim.treesitter.language.get_lang(filetype) or filetype
                if not languages[language] then
                    return
                end

                -- replicate `highlight = { enable = true }`
                vim.treesitter.start(buf, language)

                -- replicate `indent = { enable = true }`
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
