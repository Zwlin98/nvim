-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local rikka = require("rikka")

local KittyScrollBackEnable = {
    ["lazy.nvim"] = true,
    ["kitty-scrollback.nvim"] = true,
    ["nightfox.nvim"] = true,
    ["leap.nvim"] = true,
    ["nvim-hlslens"] = true,
    ["quick-scope"] = true,
    ["vim-smoothie"] = true,
    ["vim-repeat"] = true,
}

-- start
require("lazy").setup({
    defaults = {
        cond = function(plugin)
            if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
                if KittyScrollBackEnable[plugin.name] then
                    return true
                end
                return false
            end
            return true
        end,
    },
    spec = {
        { import = "plugins.theme" },
        { import = "plugins.common" },
        { import = "plugins.ui" },
        { import = "plugins.git" },
        { import = "plugins.lsp" },
        { import = "plugins.treesitter" },
    },
    ui = {
        border = rikka.border,
        backdrop = 100,
    },
})
