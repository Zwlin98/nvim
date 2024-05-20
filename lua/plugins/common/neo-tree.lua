local rikka = require("rikka")
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        local events = require("neo-tree.events")

        local opts = {
            popup_border_style = rikka.border,
            filesystem = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
            },
            window = {
                mappings = {
                    ["1"] = {
                        function()
                            vim.api.nvim_exec2("Neotree focus filesystem left", { output = false })
                        end,
                        desc = "Switch: Filesystem",
                    },
                    ["2"] = {
                        function()
                            vim.api.nvim_exec2("Neotree focus buffers left", { output = false })
                        end,
                        desc = "Switch: Buffers",
                    },
                    ["3"] = {
                        function()
                            vim.api.nvim_exec2("Neotree focus git_status left", { output = false })
                        end,
                        desc = "Switch: Git status",
                    },
                    ["<C-v>"] = "open_vsplit",
                },
            },
            buffers = {
                window = {
                    mappings = {
                        ["x"] = "buffer_delete",
                    },
                },
            },
            git_status = {
                window = {
                    mappings = {
                        ["<space>"] = {
                            function(state)
                                local node = state.tree:get_node()
                                if node.type == "message" then
                                    return
                                end
                                local path = node:get_id()

                                if rikka.isStaged(path) then
                                    local cmd = { "git", "reset", "--", path }
                                    vim.fn.system(cmd)
                                else
                                    local cmd = { "git", "add", path }
                                    vim.fn.system(cmd)
                                end

                                events.fire_event(events.GIT_EVENT)
                            end,
                            desc = "Toggle staged",
                        },
                    },
                },
            },
            source_selector = {
                winbar = true,
                sources = {
                    {
                        source = "filesystem",
                        display_name = "  Files ",
                    },
                    {
                        source = "buffers",
                        display_name = "  Buffers ",
                    },
                    {
                        source = "git_status",
                        display_name = "  Git ",
                    },
                },
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function()
                        vim.api.nvim_exec2("Neotree close", { output = false })
                    end,
                },
            },
        }
        local neotree = require("neo-tree")

        neotree.setup(opts)

        rikka.setKeymap("n", "<space>e", ":Neotree last toggle<CR>", { desc = "Open NeoTree" })
    end,
}
