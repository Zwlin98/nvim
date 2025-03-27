return {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    config = function()
        local navic = require("nvim-navic")

        navic.setup({
            icons = {
                File = "󰈙 ",
                Module = " ",
                Namespace = "󰌗 ",
                Package = " ",
                Class = "󰌗 ",
                Method = "󰆧 ",
                Property = " ",
                Field = " ",
                Constructor = " ",
                Enum = "󰕘",
                Interface = "󰕘",
                Function = "󰊕 ",
                Variable = "󰆧 ",
                Constant = "󰏿 ",
                String = "󰀬 ",
                Number = "󰎠 ",
                Boolean = "◩ ",
                Array = "󰅪 ",
                Object = "󰅩 ",
                Key = "󰌋 ",
                Null = "󰟢 ",
                EnumMember = " ",
                Struct = "󰌗 ",
                Event = " ",
                Operator = "󰆕 ",
                TypeParameter = "󰊄 ",
            },
            lsp = {
                auto_attach = true,
                preference = nil,
            },
            highlight = false,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            safe_output = true,
            lazy_update_context = false,
            click = false,
        })
    end,
}
