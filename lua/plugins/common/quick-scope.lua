vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

return {
    'unblevable/quick-scope',
    config = function()
        vim.cmd([[highlight QuickScopePrimary guifg='#bbffcc' gui=underline ctermfg=155 cterm=underline]])
        vim.cmd([[highlight QuickScopeSecondary guifg='#66ccff' gui=underline ctermfg=81 cterm=underline]])

        vim.g.qs_filetype_blacklist = { 'help', 'dashboard', 'NvimTree', "alpha" }
        vim.g.qs_buftype_blacklist = { "terminal", "nofile", "prompt" }
    end
}
