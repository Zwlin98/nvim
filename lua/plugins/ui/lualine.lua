return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "SmiteshP/nvim-navic",
        "ofseed/copilot-status.nvim",
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
                b = { fg = colors.green, bg = colors.blue },
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

        local curTime = function()
            return os.date("%H:%M:%S", os.time())
        end

        local hostname = function()
            local cache
            return function()
                if cache then
                    return cache
                end
                local data = vim.loop.os_gethostname()
                cache = string.gsub(data, "%.%w+$", "")
                return cache
            end
        end

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = theme,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                },
            },
            sections = {
                lualine_a = { {
                    "mode",
                    separator = { left = "", right = "" },
                    padding = { left = 0, right = 1 },
                } },
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                },
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
                lualine_x = {

                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "grapple", "copilot", { hostname() }, { curTime } },
                -- lualine_z = { "location" },
                lualine_z = { {
                    "progress",
                    separator = { left = "", right = "" },
                    icon = { "󰇽", align = "left" },
                    padding = { left = 0, right = 1 },
                } },
            },
            inactive_sections = {
                lualine_a = { {
                    "mode",
                    separator = { left = "", right = "" },
                    padding = { left = 0, right = 1 },
                } },
                lualine_b = {},
                lualine_c = { "filetype" },
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
