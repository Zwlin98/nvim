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
                paste_window = {
                    --- BoolOrFn? If true, use Normal highlight group. If false, use NormalFloat
                    highlight_as_normal_win = nil,
                    -- string? The filetype of the paste window. If nil, use the shell that is configured for kitty
                    filetype = nil,
                    -- boolean? If true, hide mappings in the footer when the paste window is initially opened
                    hide_footer = false,
                    -- integer? The winblend setting of the window, see :help winblend
                    winblend = 0,
                    -- KsbFooterWinOptsOverride? Paste footer window overrides, see nvim_open_win() for configuration
                    footer_winopts_overrides = nil,
                    -- string? register used during yanks to paste window, see :h registers
                    yank_register = "",
                    -- boolean? If true, the yank_register copies content to the paste window. If false, disable yank to paste window
                    yank_register_enabled = false,
                },
            },
        })
    end,
}
