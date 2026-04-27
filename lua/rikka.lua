--[[
-- 一些辅助用的 Lua 函数及变量
--]]
local Rikka = {}

Rikka.border = "rounded"

-- Color palette auto-extracted from current colorscheme.
-- To override, set e.g. rikka.color.red = "#ff0000" in lua/custom/colorOverride.lua
-- Mapping: rikka color name → { highlight_group, attribute }
local colorSources = {
    -- accents → fg
    red     = { "DiagnosticError", "fg" },
    green   = { "String", "fg" },
    yellow  = { "DiagnosticWarn", "fg" },
    blue    = { "DiagnosticInfo", "fg" },
    violet  = { "DiagnosticHint", "fg" },
    cyan    = { "Type", "fg" },
    orange  = { "WarningMsg", "fg" },

    -- backgrounds → bg
    black      = { "Normal", "bg" },
    lightBlack = { "CursorLine", "bg" },
    gray       = { "Folded", "bg" },
    lightGray  = { "FoldColumn", "bg" },
    deepDark   = { "StatusLine", "bg" },
    cursorGray = { "Visual", "bg" },

    -- foregrounds → fg
    white         = { "Normal", "fg" },
    lightWhite    = { "NonText", "fg" },
    grayWhite     = { "Comment", "fg" },
    blameGray     = { "Comment", "fg" },
    noVisualGray  = { "ColorColumn", "bg" },
}

Rikka.color = setmetatable({}, {
    __index = function(t, k)
        local source = colorSources[k]
        if not source then
            return nil
        end
        local group, attr = source[1], source[2]
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok and hl and hl[attr] then
            local c = string.format("#%06x", hl[attr])
            rawset(t, k, c)
            return c
        end
        return nil
    end,
})

function Rikka.refreshColors()
    for k in pairs(colorSources) do
        rawset(Rikka.color, k, nil)
    end
end

function Rikka.getVisualSelection()
    vim.cmd([[noau normal! "vy"]])
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", {})

    if #text > 0 then
        return text
    else
        return ""
    end
end

function Rikka.getCurrentSelectionRange()
    local line1 = vim.fn.getpos(".")[2]
    local line2 = vim.fn.getpos("v")[2]

    local vstart, vend = line1, line2
    if line1 > line2 then
        vstart, vend = line2, line1
    end

    return vstart, vend
end

function Rikka.getCurrentWord()
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
    if Snacks then
        Snacks.notifier(msg, level, {
            title = title,
        })
    else
        vim.notify(msg, level)
    end
end

function Rikka.info(format, ...)
    local msg = string.format(format, ...)
    Rikka.notify(msg, vim.log.levels.INFO, "INFO")
end

function Rikka.warn(format, ...)
    local msg = string.format(format, ...)
    Rikka.notify(msg, vim.log.levels.WARN, "WARNING")
end

function Rikka.error(format, ...)
    local msg = string.format(format, ...)
    Rikka.notify(msg, vim.log.levels.ERROR, "ERROR")
end

function Rikka.setKeymap(mode, lhs, rhs, opts)
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

function Rikka.setBufKeymap(buffer, mode, lhs, rhs, opts)
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

--- @param cmd string Vimscript code
Rikka.vimCmd = function(cmd)
    vim.api.nvim_exec2(cmd, { output = false })
end

function Rikka.getDiagnosticText()
    local line = vim.fn.line(".") - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = line })
    if #diagnostics > 0 then
        return table.concat(
            vim.tbl_map(function(d)
                return d.message
            end, diagnostics),
            " "
        )
    end
end

return Rikka
