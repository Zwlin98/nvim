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

function Rikka.isLocal()
    return not Rikka.isRemote()
end

function Rikka.isRemote()
    return os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY") or os.getenv("SSH_CONNECTION")
end

function Rikka.prequire(module)
    local ok, result = pcall(require, module)
    if ok then
        return result
    else
        return nil
    end
end

function Rikka.isBigFile(bufnr)
    local maxSize = 1024 * 1024 -- 1MB
    local maxLine = 2048
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    local lineCount = vim.api.nvim_buf_line_count(bufnr)
    if ok and stats then
        if stats.size > maxSize then
            return true
        end
        if lineCount > maxLine then
            return true
        end
    end
    return false
end

Rikka.setKeymap = vim.keymap.set

Rikka.createAutocmd = vim.api.nvim_create_autocmd

Rikka.createCommand = vim.api.nvim_create_user_command

return Rikka
