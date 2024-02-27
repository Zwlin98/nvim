return {
    "wakatime/vim-wakatime",
    lazy = false,
    setup = function()
        vim.cmd([[packadd wakatime/vim-wakatime]])
    end,
}
