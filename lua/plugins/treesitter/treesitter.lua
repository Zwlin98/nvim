return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter")

        treesitter.install("stable")

        local languages = {}
        for _, lang in ipairs(treesitter.get_available()) do
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
