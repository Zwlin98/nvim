--[[
-- 一些辅助用的 Lua 函数及变量
--]]
local Rikka = {}

Rikka.border = "rounded"

Rikka.color = {}
Rikka.color.red = "#bf717a"
Rikka.color.green = "#a3be8c"
Rikka.color.yellow = "#ebcb8b"
Rikka.color.blue = "#81a1c1"
Rikka.color.violet = "#b48ead"
Rikka.color.cyan = "#88c0d0"
Rikka.color.orange = "#d08770"

Rikka.color.black = "#2e3440"
Rikka.color.lightBlack = "#3b4252"

Rikka.color.gray = "#434c5e"
Rikka.color.lightGray = "#4c566a"

Rikka.color.white = "#eceff4"
Rikka.color.lightWhite = "#e5e9f0"
Rikka.color.grayWhite = "#d8dee9"

Rikka.color.deepDark = "#1a1a1f"
Rikka.color.cursorGray = "#444c5e"

Rikka.color.blameGray = "#777777"

Rikka.color.noVisualGray = "#3E4A59"

function Rikka.getVisualSelection()
    vim.cmd([[noau normal! "vy"]])
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ""
    end
end

function Rikka.getCurrrentWord()
    local ok, word = pcall(vim.fn.expand, "<cword>")
    if ok then
        return word
    end
end

function Rikka.isLocal()
    return not Rikka.isRemote()
end

function Rikka.isRemote()
    return os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY") or os.getenv("SSH_CONNECTION")
end

function Rikka.isTmux()
    return os.getenv("TMUX")
end

function Rikka.gitStatus(path)
    local statusCmd = { "git", "status", "--porcelain", path }
    local ok, res = pcall(vim.fn.system, statusCmd)
    if not ok then
        return
    end
    return string.sub(res, 1, 2)
end

function Rikka.isStaged(path)
    local status = Rikka.gitStatus(path)
    if not status then
        return false
    end
    local X = string.sub(status, 1, 1)
    return X ~= " "
end

function Rikka.notifyLSPError()
    return not os.getenv("NVIM_NOT_NOTIFY_LSP_ERROR")
end

function Rikka.wrapMsg(msg, maxWidth)
    maxWidth = maxWidth or 40
    local words = {}
    for word in msg:gmatch("%S+") do
        table.insert(words, word)
    end

    local lines = {}
    local currentLine = ""
    for _, word in ipairs(words) do
        local newLine = currentLine .. " " .. word
        if #newLine > maxWidth then
            table.insert(lines, currentLine)
            currentLine = word
        else
            currentLine = newLine
        end
    end
    table.insert(lines, currentLine)

    return table.concat(lines, "\n")
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

    vim.tbl_extend("keep", opts, {
        noremap = true,
        silent = true,
    })

    if type(rhs) == "function" then
        opts.callback = rhs
        rhs = ""
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

Rikka.setBufKeymap = function(buffer, mode, lhs, rhs, opts)
    opts = opts or {}

    vim.tbl_extend("keep", opts, {
        noremap = true,
        silent = true,
    })

    if type(rhs) == "function" then
        opts.callback = rhs
        rhs = ""
    end

    vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
end

Rikka.createAutocmd = vim.api.nvim_create_autocmd

Rikka.createCommand = vim.api.nvim_create_user_command

Rikka.setHightlight = function(group, opts)
    opts = opts or {}
    vim.api.nvim_set_hl(0, group, opts)
end

return Rikka
