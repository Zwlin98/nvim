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
                            rikka.vimCmd("Neotree focus filesystem left")
                        end,
                        desc = "Switch: Filesystem",
                    },
                    ["2"] = {
                        function()
                            rikka.vimCmd("Neotree focus buffers left")
                        end,
                        desc = "Switch: Buffers",
                    },
                    ["3"] = {
                        function()
                            rikka.vimCmd("Neotree focus git_status left")
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
                                local statusCmd = { "git", "status", "--porcelain", path }

                                local function statusCallback(obj)
                                    local status = string.sub(obj.stdout, 1, 1)
                                    if status == " " then
                                        vim.system({ "git", "add", path }, nil, function()
                                            events.fire_event(events.GIT_EVENT)
                                        end)
                                    else
                                        vim.system({ "git", "reset", path }, nil, function()
                                            events.fire_event(events.GIT_EVENT)
                                        end)
                                    end
                                end

                                vim.system(statusCmd, { text = true }, statusCallback)
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
                        rikka.vimCmd("Neotree close")
                    end,
                },
            },
        }
        local neotree = require("neo-tree")

        neotree.setup(opts)

        rikka.setKeymap("n", "<space>e", ":Neotree last toggle<CR>", { desc = "Open NeoTree" })
    end,
}
