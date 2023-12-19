return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "SmiteshP/nvim-navic",
    },
    config = function()
        local navic = require("nvim-navic")
        local rikka = require("rikka")

        local colors = {
            gray = rikka.color.gray,
            yellow = rikka.color.yellow,
            blue = rikka.color.blue,
            violet = rikka.color.violet,
            black = rikka.color.lightBlack,
            white = rikka.color.white,
            green = rikka.color.green,
            trans = nil,
        }

        local theme = {
            normal = {
                a = { fg = colors.black, bg = colors.green, gui = "bold" },
                b = { fg = colors.green, bg = colors.trans },
                c = { fg = colors.white, bg = colors.trans },
            },
            visual = {
                a = { fg = colors.black, bg = colors.violet, gui = "bold" },
                b = { fg = colors.violet, bg = colors.trans },
                c = { fg = colors.white, bg = colors.trans },
            },
            command = {
                a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
                b = { fg = colors.white, bg = colors.trans },
                c = { fg = colors.white, bg = colors.trans },
            },
            inactive = {
                a = { fg = colors.white, bg = colors.gray, gui = "bold" },
                b = { fg = colors.black, bg = colors.blue },
                c = { fg = colors.white, bg = colors.trans },
            },
            replace = {
                a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
                b = { fg = colors.yellow, bg = colors.trans },
                c = { fg = colors.white, bg = colors.trans },
            },
            insert = {
                a = { fg = colors.black, bg = colors.blue, gui = "bold" },
                b = { fg = colors.blue, bg = colors.trans },
                c = { fg = colors.white, bg = colors.trans },
            },
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = theme,
                component_separators = { left = "|", right = "|" },
                section_separators = { left = " ", right = " " },
                disabled_filetypes = {
                    statusline = { "neo-tree" },
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    { "filename", path = 1 },
                    {
                        function()
                            return navic.get_location()
                        end,
                        cond = function()
                            return navic.is_available()
                        end,
                    },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
    end,
}
