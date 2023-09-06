return {
    'unblevable/quick-scope',
    config = function()
        vim.cmd([[highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline]])
        vim.cmd([[highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline]])
        vim.g.qs_filetype_blacklist = { 'help', 'dashboard', 'NvimTree', "alpha" }
        vim.g.qs_buftype_blacklist = { "terminal", "nofile", "prompt" }
    end
}
