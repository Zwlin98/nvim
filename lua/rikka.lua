--[[
-- 一些辅助用的 Lua 函数
--]]
Rikka = {}

Rikka.border = "rounded"

function Rikka.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end

function Rikka.localOnly()
    return not os.getenv("SSH_CLIENT")
end

function Rikka.prequire(module)
    local ok, result = pcall(require, module)
    if ok then
        return result
    else
        return nil
    end
end

Rikka.setKeymap = vim.keymap.set

Rikka.createAutocmd = vim.api.nvim_create_autocmd

Rikka.createCommand = vim.api.nvim_create_user_command

return Rikka
