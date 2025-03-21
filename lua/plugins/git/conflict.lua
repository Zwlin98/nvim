return {
    "akinsho/git-conflict.nvim",
    version = "v0.1.0",
    config = function()
        require("git-conflict").setup({
            default_mappings = true, -- disable buffer local mapping created by this plugin
            default_commands = true, -- disable commands created by this plugin
            disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
            list_opener = "copen", -- command or function to open the conflicts list
            highlights = { -- They must have background color, otherwise the default color will be used
                incoming = "DiffAdd",
                current = "DiffText",
            },
        })
    end,
}
