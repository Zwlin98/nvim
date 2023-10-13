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
        }

        local theme = {
            normal = {
                b = { fg = colors.green, bg = colors.black },
                a = { fg = colors.black, bg = colors.green, gui = "bold" },
                c = { fg = colors.white, bg = colors.black },
            },
            visual = {
                b = { fg = colors.violet, bg = colors.black },
                a = { fg = colors.black, bg = colors.violet, gui = "bold" },
            },
            inactive = {
                b = { fg = colors.black, bg = colors.blue },
                a = { fg = colors.white, bg = colors.gray, gui = "bold" },
            },
            replace = {
                b = { fg = colors.yellow, bg = colors.black },
                a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
                c = { fg = colors.white, bg = colors.black },
            },
            command = {
                a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
                b = { bg = colors.lightgray, fg = colors.white },
                c = { bg = colors.inactivegray, fg = colors.black },
            },
            insert = {
                b = { fg = colors.blue, bg = colors.black },
                a = { fg = colors.black, bg = colors.blue, gui = "bold" },
                c = { fg = colors.white, bg = colors.black },
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
