local rikka = require("rikka")
return {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = rikka.isLocal,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth", "KittyScrollbackGenerateCommandLineEditing" },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
        require("kitty-scrollback").setup({
            {
                callbacks = {
                    after_setup = function()
                        vim.o.signcolumn = "no"
                    end,
                    after_ready = function()
                        vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- 移动到最开始
                    end,
                },
            },
        })
    end,
}
