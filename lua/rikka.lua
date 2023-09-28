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

Rikka.notify = function(msg, level, title)
    local notify = Rikka.prequire("notify")
    if notify then
        notify(msg, level, { title = title, timeout = 1000 })
    else
        vim.notify(msg, level)
    end
end

Rikka.info = function(msg, title)
    Rikka.notify(msg, vim.log.levels.INFO, title)
end

Rikka.warn = function(msg, title)
    Rikka.notify(msg, vim.log.levels.WARN, title)
end

Rikka.error = function(msg, title)
    Rikka.notify(msg, vim.log.levels.ERROR, title)
end

Rikka.setKeymap = function(mode, lhs, rhs, opts)
    opts = opts or {}

    if opts.noremap == nil then
        opts.noremap = true
    end
    if opts.silent == nil then
        opts.silent = true
    end

    if type(rhs) == 'function' then
        opts.callback = rhs
        rhs = ''
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

Rikka.setBufKeymap = function(buffer, mode, lhs, rhs, opts)
    opts = opts or {}

    if opts.noremap == nil then
        opts.noremap = true
    end
    if opts.silent == nil then
        opts.silent = true
    end

    if type(rhs) == 'function' then
        opts.callback = rhs
        rhs = ''
    end

    vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
end

Rikka.createAutocmd = vim.api.nvim_create_autocmd

Rikka.createCommand = vim.api.nvim_create_user_command

return Rikka
