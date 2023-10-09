local rikka = require("rikka")

return {
    "keaising/im-select.nvim",
    enabled = rikka.isLocal,
    config = function()
        require("im_select").setup({

            default_im_select = "com.apple.keylayout.ABC",

            -- Can be binary's name or binary's full path,
            -- e.g. 'im-select' or '/usr/local/bin/im-select'
            -- For Windows/WSL, default: "im-select.exe"
            -- For macOS, default: "im-select"
            -- For Linux, default: "fcitx5-remote" or "fcitx-remote" or "ibus"
            default_command = "im-select",

            -- Restore the default input method state when the following events are triggered
            set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },

            -- Restore the previous used input method state when the following events are triggered
            -- if you don't want to restore previous used im in Insert mode,
            -- e.g. deprecated `disable_auto_restore = 1`, just let it empty `set_previous_events = {}`
            set_previous_events = { "InsertEnter" },

            -- Show notification about how to install executable binary when binary is missing
            keep_quiet_on_no_binary = true,

            -- Async run `default_command` to switch IM or not
            async_switch_im = true,
        })
    end,
}
